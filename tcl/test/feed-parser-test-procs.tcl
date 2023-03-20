ad_library {

    Feed Parser Tests

}

ad_proc -private feed_parser::test::parse_feed {
    -xml:required
} {
    Checks basic functionality of feed_parser::parse_feed.

    @see feed_parser::parse_feed
    @return dict containing variables 'success_p' and 'result',
            indicating respectively whether test succeeded and the
            content that was retrieved
} {
    set parsing_failed_p [expr {[catch {
        set result [feed_parser::parse_feed -xml [string trim $xml]]
    } errmsg] || ![dict exists $result status] || [dict get $result status] eq "error"}]
    aa_false "Parsing XML succeeds." $parsing_failed_p
    if {$parsing_failed_p} {
        aa_error "Error was: $errmsg"
        return [list success_p false result ""]
    }

    set format_ok_p [expr {
                           [dict exists $result channel] &&
                           [dict exists $result items]
                       }]
    aa_true "Feed parsing contains expected 'channel' and 'item' elements." $format_ok_p
    if {!$format_ok_p} {
        aa_error "Result was: $result"
        return [list success_p false result $result]
    }

    set channel [dict get $result channel]
    set format_ok_p [expr {
                           [dict exists $channel title] &&
                           [dict exists $channel link] &&
                           [dict exists $channel description]
                       }]
    aa_true "Feed channel contains expected 'title', 'link' and 'description' elements." $format_ok_p
    if {!$format_ok_p} {
        aa_error "Channel was: $channel - [dict get $result error]"
        return [list success_p false result $result]
    }

    return [list success_p true result $result]
}

aa_register_case -cats {
    smoke
} -procs {
    util::http::get
    feed_parser::parse_feed
} parse_feed_ok {
    Check that all source feeds currently configured keep being valid
    and parseable
} {
    # Set a test XML content
    set xml {
        <?xml version="1.0" encoding="utf-8"?>
        <rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">
        <channel>
        <title>Studierende</title>
        <link>https://www.wu.ac.at/</link>
        <description>Die WU (Wirtschaftsuniversität Wien) zeichnet sich durch ein attraktives Studienangebot, einen effizienten Studienbetrieb und eine breite Palette an Spezialisierungen und Forschungsrichtungen aus.</description>
        <language>en-us</language>
        <copyright>Wirtschaftsuniversität Wien (WU)</copyright>
        <pubDate>Thu, 19 Jul 2018 08:01:06 +0200</pubDate>
        <lastBuildDate>Thu, 19 Jul 2018 08:01:06 +0200</lastBuildDate>

        <generator></generator>
        <item>
        <guid isPermaLink="false">news-10898</guid>
        <pubDate>Wed, 06 Jun 2018 14:32:41 +0200</pubDate>
        <title>Neue SBWL Strategy &amp; Organization ab WS 2018/19 </title>
        <link>https://www.wu.ac.at/studierende/news-details/detail/neue-sbwl-strategy-organization-ab-ws-201819/</link>
        <description>Ab dem Wintersemester 2018/19 wird vom Institut für Organization Design die neue SBWL Strategy &amp; Organization (Prof. Dr. Patricia Klarner) angeboten. </description>
        <content:encoded><![CDATA[<p>Die SBWL Strategy &amp; Organization wird in englischer Sprache angeboten und umfasst fünf obligatorische Kurse, welche innerhalb von zwei Semestern absolviert werden können: </p><ul class="ul-square"><li><p>     Kurs I: Strategic Organization Design     </p></li><li><p>Kurs II: Organizational Change and Redesign </p></li><li><p>    Kurs III: Skills Development Workshop “Project Management”     </p></li><li><p>Kurs IV: Cases in Strategy &amp; Organization     </p></li><li><p>Kurs V: Project Course “Strategy &amp; Organization”  </p></li></ul><p>Der Einstieg in die SBWL erfolgt durch Ausfüllen eines Bewerbungsformulars und dem Übermitteln von Lebenslauf, Notenauszug und Motivationsschreiben über die Institutswebsite.
                                  </p>
                                  <p>Mindeststudiendauer: Diese SBWL kann in zwei Semestern abgeschlossen werden. Insgesamt stehen jedes Semester 30 Plätze zur Verfügung.
                                  </p>
                                  <p>Nähere Informationen zur SBWL finden Sie online unter: <a href="https://www.wu.ac.at/iod/lehre/bachelorstudium/" >https://www.wu.ac.at/iod/lehre/bachelorstudium/</a>&nbsp;
                                  </p>
                                  <p>Das Institut für Organization Design freut sich über Ihre Bewerbung.</p>]]></content:encoded>
        </item><item>
        <guid isPermaLink="false">news-10891</guid>
        <pubDate>Wed, 06 Jun 2018 11:11:21 +0200</pubDate>
        <title>Update! Juni 2018</title>
        <link>https://www.wu.ac.at/studierende/news-details/detail/update-juni-2018/</link>
        <description>Themen: Neue SBWL Strategy &amp; Organization / Schreibmentor/inn/en für WS 18/19 gesucht / Projektabschluss Changemaker Programm / SBWL International Business mit neuem Track Central Europe Connect / Bewerbung für ein Auslandssemester im SS 2019 </description>
        <content:encoded><![CDATA[<h4>Neue SBWL Strategy &amp; Organization ab WS 2018/19  </h4>
                                  <p>Ab dem <strong>Wintersemester 2018/19 </strong>wird vom Institut für Organization Design die <strong>neue SBWL Strategy &amp; Organization</strong> (Prof. Dr. Patricia Klarner) angeboten. Die SBWL Strategy &amp; Organization wird in englischer Sprache angeboten und umfasst fünf obligatorische Kurse, welche innerhalb von zwei Semestern absolviert werden können: </p><ul class="ul-square"><li><p>Kurs I: Strategic Organization Design </p></li><li><p>Kurs II: Organizational Change and Redesign </p></li><li><p>Kurs III: Skills Development Workshop “Project Management” </p></li><li><p>Kurs IV: Cases in Strategy &amp; Organization </p></li><li><p>Kurs V: Project Course “Strategy &amp; Organization” </p></li></ul><p>Der Einstieg in die SBWL erfolgt durch Ausfüllen eines Bewerbungsformulars und dem Übermitteln von Lebenslauf, Notenauszug und Motivationsschreiben über die Institutswebsite.
                                  </p>
                                  <p>Mindeststudiendauer: Diese SBWL kann in zwei Semestern abgeschlossen werden.
                                  </p>
                                  <p>Insgesamt stehen jedes Semester 30 Plätze zur Verfügung.
                                  </p>
                                  <p>Nähere Informationen zur SBWL finden Sie online unter:   <a href="https://www.wu.ac.at/iod/lehre/bachelorstudium/" >https://www.wu.ac.at/iod/lehre/bachelorstudium/</a>&nbsp;
                                  </p>
                                  <p>Das Institut für Organization Design freut sich über Ihre Bewerbung.
                                  </p>
                                  <h4>Schreibmentor/inn/en für das Wintersemester 2018/19 gesucht </h4>
                                  <p><strong>Masterstudierende</strong> und <strong>höhersemestrige Bachelorstudierende (ab 150 ECTS)</strong> haben die Möglichkeit, Studienkolleg/inn/en auf der Bachelorebene beim Erwerb der akademischen Schlüsselqualifikation Schreiben zu unterstützen und dabei selbst von der umfassenden Ausbildung, die sie im Rahmen ihrer Tätigkeit als Schreibmentor/inn/en erhalten, zu profitieren.
                                  </p>
                                  <p><strong>Was tun Schreibmentor/inn/en? </strong></p><ul class="ul-square"><li><p>Sie gestalten im Zweierteam wöchentliche Schreibgruppen. </p></li><li><p>Sie nehmen an einer Supervisions-Lehrveranstaltung während des Semesters teil.  </p></li></ul><p><strong>Was Sie im Rahmen Ihrer Tätigkeit als Schreibmentor/in erhalten:</strong> </p><ul class="ul-square"><li><p>Ausbildung zum/zur Schreibmentor/in </p></li><li><p>Eine Teilnahmebestätigung, die Sie u.a. bei Bewerbungen vorweisen können</p></li><li><p>4 ECTS-Credits, die als freies Wahlfach angerechnet werden können </p></li></ul><p>Wenn Sie sich als Schreibmentor/in engagieren möchten, <strong>bewerben Sie sich bis 10. Juli 2018</strong>.
                                  </p>
                                  <p>Alle Infos zum Programm und zur Bewerbung finden Sie unter: <a href="https://www.wu.ac.at/studierende/mein-studium/masterguide/foerderprogramme/schreibmentoring/" >https://www.wu.ac.at/studierende/mein-studium/masterguide/foerderprogramme/schreibmentoring/</a>
                                  </p>
                                  <h4>300 Volksschulkinder beim Projektabschluss des Changemaker-Programms auf dem WU Campus </h4>
                                  <p>Am Mittwoch, den 23. Mai hat sich ein Teil des WU Campus in einen Markttag der besonderen Art verwandelt. Im großen Foyer des Teaching Centers haben die Schulkinder gemeinsam mit den Studierenden des Changemaker-Programms einen Marktplatz gestaltet und ihre eigenen Ideen präsentiert.
                                  </p>
                                  <p>Zuvor haben die Studierenden die Kinder bereits in mehreren Workshops an das Thema Entrepreneurship herangeführt und mit ihnen ihre Ideen vorbereitet. Davor wiederum durchliefen die Studierenden selbst zuerst eine Online-Phase und dann Workshops, um sich mit dem Thema vertraut zu machen.
                                  </p>
                                  <p>Sie sind WU Student/in, Entrepreneurship-interessiert und möchten ebenfalls im 2. Durchgang des WU Changemaker Programms ein Impact Projekt umsetzen?
                                  </p>
                                  <p><strong>Dann kommen Sie zur Changemaker Infoveranstaltung am Dienstag, den 19.06.2018, 15:00 - 16:00 Uhr, ins WU Gründungszentrum.</strong> <a href="https://www.facebook.com/events/632463453757496" target="_blank" class="external">Hier geht es zum Facebook Event.</a>
                                  </p>
                                  <p>Weitere Informationen zum Programm: <a href="https://www.wu.ac.at/gruenden/programme/wu-changemaker-program/" target="_blank">http://changemaker.wien/</a>&nbsp; &nbsp;
                                  </p>
                                  <h4>Central Europe Connect: Die SBWL International Business hat einen neuen Track und dadurch 20 weitere Plätze! </h4>
                                  <p>Sie sind Bachelorstudent/in, interessieren sich für die <a href="https://www.wu.ac.at/iib/studies/sbwl/" target="_blank">SBWL International Business</a> und wollen „mehrere Fliegen mit einer Klappe schlagen“? Dann schauen Sie hier genauer hin…
                                  </p>
                                  <p>Im Zuge der Aufnahme in die SBWL International Business bewerben Sie sich für Central Europe Connect und besuchen Kurs 3, 4 und 5 zusammen mit Studierenden der University of Economics in Bratislava (EUBA) und SGH Warsaw School of Economics an deren Campus-Standorten. Die einwöchigen Blocklehrveranstaltungen über internationale Unternehmensführung im mitteleuropäischen Kontext werden abgerundet durch Unternehmensbesuche und Networking Events. Bei erfolgreicher Absolvierung von Central Europe Connect erhalten Sie ein Joint Certificate und können sich 8 ECTS-Credits für die <a href="https://www.wu.ac.at/studierende/im-ausland-studieren/bachelor/ibw-auslandserfahrung/" target="_blank">IBW-Auslandserfahrung</a> anerkennen lassen. Die Reisen ins Ausland werden finanziell unterstützt.
                                  </p>
                                  <p>Informieren Sie sich auf <a href="https://www.wu.ac.at/iib/studies/sbwl/track-central-europe-connect/" target="_blank">https://www.wu.ac.at/iib/studies/sbwl/central-europe-connect/</a> und kommen Sie bei der <a href="https://www.facebook.com/events/159574684694277/" target="_blank" class="external">ÖH SBWL Messe</a> am <strong>7. Juni um 10:30 Uhr (LC Forum)</strong> zur International Business Präsentation von Prof. Puck!
                                  </p>
                                  <h4>Lust auf ein Auslandssemester? Dann bewerben Sie sich jetzt noch für das Sommersemester 2019! </h4>
                                  <p><strong>Bewerbungszeitraum: 18. Juni – 22. Juni 2018 </strong>
                                  </p>
                                  <p><strong>Bachelorstudierende</strong>, die im Sommersemester 2019 ein Auslandssemester an einer unserer Partneruniversitäten in <strong>Europa </strong>oder in <strong>Übersee </strong>absolvieren möchten, können sich bis zum 22. Juni 2018 (bis 12 Uhr Mittag) während unseres <strong>Zusatztermins </strong>bewerben.
                                  </p>
                                  <p>Nutzen Sie unser Angebot an Kleingruppenberatungen, in denen Sie sich vor, während und nach dem Auslandssemester über Verschiedenes rund um das Auslandssemester informieren können. Genauere Infos dazu finden Sie auf unserer <a href="https://www.wu.ac.at/studierende/im-ausland-studieren/termine-und-fristen/" target="_blank">Dates &amp; Deadlines Seite</a>.
                                  </p>
                                  <p>Mehr Informationen zum Austauschsemester finden Sie unter <a href="https://www.wu.ac.at/studierende/im-ausland-studieren/" target="_blank">Outgoing Austauschstudierende</a>.</p>]]></content:encoded>
        </item><item>
        <guid isPermaLink="false">news-10859</guid>
        <pubDate>Fri, 01 Jun 2018 12:41:09 +0200</pubDate>
        <title>Neuer Track innerhalb der SBWL International Business: Central Europe Connect</title>
        <link>https://www.wu.ac.at/studierende/news-details/detail/neuer-track-innerhalb-der-sbwl-international-business-central-europe-connect/</link>
        <description>Absolvieren Sie einen Teil der SBWL IB zusammen mit Studierenden von zwei WU Partneruniversitäten und bauen sich ein Netzwerk in Europas am schnellsten wachsender Region auf. Erfahren Sie mehr auf der ÖH SBWL Messe am 07.06.2018!</description>
        <content:encoded><![CDATA[<p>Das Joint Certificate Program Central Europe Connect wird von der WU zusammen mit der University of Economics in Bratislava (EUBA) und der SGH Warsaw School of Economics organisiert. Die Bewerbung erfolgt beim Einstiegstest in die SBWL International Business im Herbst 2018.
                                  </p>
                                  <p><strong>Was erwartet Sie?</strong> </p><ul class="ul-square"><li><p>Absolvierung der SBWL IB Kurse 3, 4 &amp; 5 mit internationalen Studierenden</p></li><li><p>3 Locations: Wien, Bratislava, Warschau </p></li><li><p>3 einwöchige Blockkurse innerhalb eines Semesters </p></li><li><p>Networking Events mit internationalen Unternehmen </p></li><li><p>12 ECTS-Credits (4 pro Kurs) </p></li><li><p>Bestätigung von 8 ECTS-Credits für die IBW-Auslandserfahrung </p></li><li><p>Joint Certificate von drei renommierten Universitäten </p></li><li><p>Finanzielle Unterstützung für die Reisen ins Ausland </p></li><li><p>Englisch als Unterrichtssprache </p></li></ul><p><strong>Sie sind interessiert? </strong>
                                  </p>
                                  <p>Informieren Sie sich auf <a href="https://www.wu.ac.at/iib/studies/sbwl/central-europe-connect/" >https://www.wu.ac.at/iib/studies/sbwl/central-europe-connect/</a> und kommen Sie bei der <a href="https://www.facebook.com/events/159574684694277/" target="_blank" class="external">ÖH SBWL Messe</a> <strong>am 7. Juni um 10:30 Uhr</strong> (LC Forum) zur International Business Präsentation von Prof. Puck!</p>]]></content:encoded>
        </item><item>
        <guid isPermaLink="false">news-10590</guid>
        <pubDate>Fri, 27 Apr 2018 12:15:53 +0200</pubDate>
        <title>Update! Mai 2018</title>
        <link>https://www.wu.ac.at/studierende/news-details/detail/update-mai-2018/</link>
        <description>Themen: Lust auf ein Auslandssemester? / Bewerbungsfrist für deutsche Masterstudien / Wie finde ich Abschlussarbeiten zu einem bestimmten Thema oder von einem/einer bestimmten Betreuer/in? / Werden Sie Mentor/in / Career Insights - Einblicke in Jobs und Bewerbung / Werden Sie Lern- oder Musikbuddy</description>
        <content:encoded><![CDATA[<h4>Lust auf ein Auslandssemester? Dann bewerben Sie sich jetzt für das Sommersemester 2019!  </h4>
                                  <p><strong>Bewerbungszeitraum: 07. Mai – 16. Mai 2018</strong>
                                  </p>
                                  <p><strong>Bachelorstudierende</strong>, die im Sommersemester 2019 ein Auslandssemester an einer unserer Partneruniversitäten in <strong>Europa </strong>absolvieren möchten, können sich bis zum 16. Mai 2018 (bis 12 Uhr Mittag) bewerben.
                                  </p>
                                  <p><strong>Masterstudierende </strong>können sich im selben Zeitraum für Universitäten in <strong>Europa </strong>und in <strong>Übersee </strong>bewerben.
                                  </p>
                                  <p>Nutzen Sie unser Angebot an <strong>Kleingruppenberatungen</strong>, in denen Sie sich vor, während und nach dem Auslandssemester über Verschiedenes rund um das Auslandssemester informieren können. Genauere Infos dazu finden Sie auf unserer Seite <a href="https://www.wu.ac.at/studierende/im-ausland-studieren/termine-und-fristen/" target="_blank">Termine und Fristen</a>.
                                  </p>
                                  <p>Mehr Informationen zum Austauschsemester finden Sie unter <a href="https://www.wu.ac.at/studierende/im-ausland-studieren/" target="_blank">Im Ausland studieren</a>.
                                  </p>
                                  <h4>Bewerbungsfrist für deutsche Masterstudien </h4>
                                  <p>Die Bewerbungsfrist für die deutschsprachigen Masterprogramme für das kommende Studienjahr 2018/19 läuft noch <strong>bis 31. Mai 2018</strong>. Bitte beachten Sie, dass bei allen Masterstudien (Ausnahme Wirtschaftsrecht) der Programmstart ausschließlich im Wintersemester möglich ist. Die Bewerbung ist bereits vor Studienabschluss möglich. Im Sinne einer raschen Bearbeitung empfehlen wir Studieninteressieren, sich möglichst früh zu bewerben.
                                  </p>
                                  <p>Bitte erkundigen Sie sich über die programmspezifischen Zulassungsvoraussetzungen und Assessment-Phasen.
                                  </p>
                                  <p><strong>Mehr Infos unter: </strong><a href="https://www.wu.ac.at/studium/master/" target="_blank">http://www.wu.ac.at/programs/master/</a>
                                  </p>
                                  <h4>Wie finde ich Abschlussarbeiten zu einem bestimmten Thema oder von einem/einer bestimmten Betreuer/in? </h4>
                                  <p>Diese Frage bekommen wir in der Bibliothek oft gestellt – und wir haben natürlich eine Antwort darauf.
                                  </p>
                                  <p>In der Universitätsbibliothek werden - mit Ausnahme der Bachelorarbeiten - alle an der WU verfassten Abschlussarbeiten gesammelt. Die Abschlussarbeiten befinden sich frei zugänglich im Buchbereich auf Ebene -2.
                                  </p>
                                  <p>Tipps zur Recherche und Suchbeispiele finden sich in unserem eLearning-Bereich <strong>„Recherche nach Abschlussarbeiten“</strong>: <a href="https://learn.wu.ac.at/bibliothek/thesis" target="_blank" class="external">https://learn.wu.ac.at/bibliothek/thesis</a>&nbsp;
                                  </p>
                                  <h4>Andere unterstützen und Führungserfahrung sammeln? Werden Sie Mentor/in! </h4>
                                  <p>Möchten Sie im Wintersemester 2018/19 Studienanfänger/innen im Bachelorstudium unterstützen und dabei selbst wertvolle Führungserfahrung sammeln? Im <a href="https://www.wu.ac.at/studierende/mein-studium/bachelorguide/foerderprogramme/mentoringwu/mentoring/" target="_blank">Mentoring@WU Programm</a> ist das möglich. Als Mentor/in helfen Sie in regelmäßigen Treffen einer Gruppe von neuen Studierenden bei der Organisation des Studiums. Zudem vernetzen Sie sich mit anderen Mentor/inn/en und können sich 2 ECTS-Credits als freies Wahlfach anrechnen lassen.
                                  </p>
                                  <p>Beim <strong>Mentoring@WU Infoabend</strong> stellen wir Ihnen das Programm vor, und aktuelle Mentor/inn/en teilen ihre Erfahrungen: </p><ul class="ul-square"><li><p> <strong>Wann?</strong> <strong>23. Mai 2018, 17:00 – 18:30 Uhr </strong></p></li><li><p><strong>Wo?</strong> Gebäude TC, Raum TC.3.01 </p></li><li><p><strong>Anmeldung an:</strong> <a href="mailto:mentoring@wu.ac.at">mentoring@wu.ac.at</a> </p></li></ul><p><strong>Details zum Mentoring@WU Programm</strong> und zur Bewerbung finden Sie <a href="https://www.wu.ac.at/studierende/mein-studium/bachelorguide/foerderprogramme/mentoringwu/mentoring/" target="_blank">hier</a>.
                                  </p>
                                  <h4>Career Insights: Einblicke in Jobs und Bewerbung </h4>
                                  <p><strong>23. – 28. Mai 2018, Gebäude LC</strong>
                                  </p>
                                  <p>Das WU ZBP Career Center stellt Ihnen bei den Career Insights die vielfältige Welt der <strong>Arbeitgeber und Einstiegsmöglichkeiten</strong> vor. Bei Breakfast, Skill-Labs oder Skills-Seminaren können Sie ganz ungezwungen Personalverantwortliche treffen – vielleicht auch von jenen Unternehmen, die Sie noch nicht am Radar hatten. Sie erhalten Einblicke in Berufe und können sich in Bewerbungssituationen einfühlen – ganz individuell, vertraulich und entspannt.
                                  </p>
                                  <p>Alle Infos zu den Career Insights gibt es <a href="https://www.zbp.at/de/events/eventliste/" target="_blank" class="external">hier</a>.
                                  </p>
                                  <h4>Machen Sie den Unterschied: Werden Sie Lern- oder Musikbuddy! </h4>
                                  <p>Als <a href="https://www.wu.ac.at/studierende/mein-studium/bachelorguide/foerderprogramme/volunteering/lernbuddy/" target="_blank">Lernbuddy</a> verbringen Sie regelmäßig Zeit mit Kindern und Jugendlichen aus sozial benachteiligten Familien und sind ein großes Vorbild für sie. Bei allen Freizeitaktivitäten als Lernbuddy lernen Sie auch viele gleichgesinnte Studierende kennen.
                                  </p>
                                  <p>Als <a href="https://www.wu.ac.at/studierende/mein-studium/bachelorguide/foerderprogramme/volunteering/musikbuddy/" target="_blank">Musikbuddy</a> betreuen Sie gemeinsam mit anderen Studierenden einen Kinderchor in der Brunnenpassage und proben für mehrere öffentliche Auftritte am Ende des Semesters.
                                  </p>
                                  <p>Bei unseren <strong>Infoabenden </strong>erfahren Sie mehr über die Programme und können aktuelle Buddys kennenlernen: </p><ul class="ul-square"><li><p><strong>Lernbuddy-Infoabend: am 15. Mai 2018 um 17.30 Uhr (TC.5.14) </strong></p></li><li><p><strong>Musikbuddy-Infoabend: am 15. Mai 2018 um 18.30 Uhr (TC.5.16)</strong></p></li></ul><p>Werden Sie Teil des Lern- und Musikbuddy-Netzwerks und bewerben Sie sich bei Volunteering@WU für <a href="https://www.wu.ac.at/studierende/mein-studium/bachelorguide/foerderprogramme/volunteering/lernen-macht-schule/" target="_blank">Lernen macht Schule</a>: das Kooperationsprojekt von WU, REWE und Caritas.
                                  </p>
                                  <p><strong>Weitere Infos</strong> finden Sie auf unserer <a href="https://www.wu.ac.at/studierende/mein-studium/bachelorguide/foerderprogramme/volunteering/" target="_blank">Webseite</a>.</p>]]></content:encoded>
        </item><item>
        <guid isPermaLink="false">news-10428</guid>
        <pubDate>Tue, 10 Apr 2018 08:42:05 +0200</pubDate>
        <title>Master Day am 11. April 2018</title>
        <link>https://www.wu.ac.at/studierende/news-details/detail/master-day-am-11-april-2018/</link>
        <description>Sie liebäugeln mit einem Master an der WU? Kommen Sie zum Master Day am 11. April 2018  und informieren Sie sich: Gebäude LC, Forum und Festsaal 2, 09:30 - 16:30 Uhr</description>
        <content:encoded><![CDATA[<p>Wenn Sie einen Master an der WU anstreben, ist der <a href="http://www.wu.ac.at/masterday" target="_blank" class="external">Master Day</a> genau das Richtige für Sie. Die WU bietet <a href="https://www.wu.ac.at/studium/master/" target="_blank">15 Masterprogramme</a> an - sieben in deutscher und acht in englischer Sprache.
                                  </p>
                                  <p>Beim Master Day stellen Programmverantwortliche ihre Masterprogramme im Detail vor und beantworten im Anschluss gerne Ihre Fragen. Auch die Studienzulassung ist zu Mittag vor Ort und gibt Ihnen Infos und Tipps zum Bewerbungsprozess.
                                  </p>
                                  <p>Den genauen Programmablauf finden Sie <a href="https://www.wu.ac.at/fileadmin/wu/h/structure/servicecenters/services/Newsmeldungen/Master_Day_Flyer_April_2018.pdf" target="_blank" >hier</a>.</p>]]></content:encoded>
        </item>
        </channel>
        </rss>
    }

    set test [feed_parser::test::parse_feed -xml $xml]
    set success_p [dict get $test success_p]
    aa_true "Basic stream parsing works" $success_p
    if {!$success_p} {
        return
    }

    set result [dict get $test result]

    set items [dict get $result items]
    aa_equals "Test XML contains exactly 5 items" [llength $items] 5

    set first_item [lindex $items 0]
    set permalink_p [expr {[dict exists $first_item permalink_p] ?
                           [dict get $first_item permalink_p] : ""}]
    aa_true "First item is not a permalink" [string is false -strict $permalink_p]

    # This contains umlauts and should prove itself nasty enough to
    # spot encoding issues
    set expected_description {Die WU (Wirtschaftsuniversität Wien) zeichnet sich durch ein attraktives Studienangebot, einen effizienten Studienbetrieb und eine breite Palette an Spezialisierungen und Forschungsrichtungen aus.}
    aa_equals "Channel description was parsed and decoded correctly" $expected_description [dict get [dict get $result channel] description]
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
