ad_library {
    The procs that make up our Feed Parser.
    
    @creation-date 2003-12-28
    @author Guan Yang (guan@unicast.org)
    @author Simon Carstensen (simon@bcuni.net)
}

namespace eval feed_parser {}

ad_proc -private feed_parser::remove_unsafe_html { 
    -html:required
} {
    Make sure we are consuming RSS safely by removing unsafe tags.

    See http://diveintomark.org/archives/2003/06/12/how_to_consume_rss_safely.html.

    @author Simon Carstensen
    @creation-date 2003-07-06
    @param html An HTML string that we need to clean up
    @return The cleaned-up HTML string
} {
    set unsafe_tags {
        script
        embed
        object
        frameset
        frame
        iframe
        meta
        link
        style
    }

    foreach tag $unsafe_tags {
        regsub -all "(<$tag\[^>\]*>(\[^<\]*</$tag>)?)+"  $html {} html
    }

    return $html
}

ad_proc -public feed_parser::parse_feed {
    -xml:required
    {-autodiscover:boolean 1}
} {
    Parse a string believed to be a syndication feed.
    
    @author Guan Yang (guan@unicast.org)
    @creation-date 2003-12-28
    @param xml A string containing an XML document.
    @param autodiscover If true, this procedure will, if the string turns at
                first glance not to be an XML document, treat it as an HTML
                document and attempt to extract an RSS autodiscovery element.
                If such an element is found, the URL will be retrieved using
                ad_httpget and this procedure will be applied to the content
                of that URL.
    @return A Tcl array-list data structure.
} {
    # Prefill these slots for errors
    set result(channel) ""
    set result(items) ""

    if { [catch {
        # Pre-process the doc and remove any processing instruction
        regsub {^<\?xml [^\?]+\?>} $xml {<?xml version="1.0"?>} xml
        set doc [dom parse $xml]
        set doc_node [$doc documentElement]
        set node_name [$doc_node nodeName]
    
        # feed is the doc-node name for Atom feeds
        if { [lsearch {rdf RDF rdf:RDF rss feed} $node_name] == -1 } {
            ns_log Debug "feed_parser::parse_feed: doc node name is not rdf, RDF, rdf:RDF or rss"
            set rss_p 0
        } else {
            set rss_p 1
        }
    } errmsg] } {
        ns_log Debug "feed_parser::parse_feed: error in initial itdom parse, errmsg = $errmsg"
        set rss_p 0
    }
    
    if { !$rss_p } {
        # not valid xml, let's try autodiscovery
        ns_log Debug "feed_parser::parse_feed: not valid xml, we'll try autodiscovery"
        
        set doc [dom parse -html $xml]
        set doc_node [$doc documentElement]
        
        set link_path {/html/head/link[@rel='alternate' and @title='RSS' and @type='application/rss+xml']/@href}
        set link_nodes [$doc_node selectNodes $link_path]
      
        $doc delete
    
        if { [llength $link_nodes] == 1} {
            set link_node [lindex $link_nodes 0]
            set feed_url [lindex $link_node 1]
            array set f [ad_httpget -url $feed_url]
            return [feed_parser::parse_feed -xml $f(page)]
        }
        
        set result(status) "error"
        set result(error) "Not RSS and contained no autodiscovery element"
        return [array get result]
    }
    
    if { [catch {
        set doc_name [$doc_node nodeName]
        
        if { [string equal $doc_name "feed"] } {
            # It's an Atom feed
            set channel [news_aggregator::channel_parse \
                           -channel_node $doc_node]
        } else {
            # It looks RSS/RDF'fy
            set channel [news_aggregator::channel_parse \
                -channel_node [$doc_node getElementsByTagName channel]]
        }    
            
        set item_nodes [news_aggregator::items_fetch -doc_node $doc_node]
        set item_nodes [news_aggregator::sort_result -result $item_nodes]
        set items [list]
        
        foreach item_node $item_nodes {
            lappend items [news_aggregator::item_parse -item_node $item_node]
        }
        
        $doc delete
    } err] } {
        set result(status) "error"
        set result(error) "Parse error: $err"
        return [array get result]
    } else {
        set result(status) "ok"
        set result(error) ""
        set result(channel) $channel
        set result(items) $items
        return [array get result]
    }
}
