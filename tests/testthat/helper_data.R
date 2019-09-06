library(dplyr)
library(xml2)

# atom feeds
## example feed from https://en.wikipedia.org/wiki/Atom_(Web_standard)
atom <- '<feed xmlns="http://www.w3.org/2005/Atom">

	<title>Example Feed</title>
	<subtitle>A subtitle.</subtitle>
	<link href="http://example.org/feed/" rel="self" />
	<link href="http://example.org/" />
	<id>urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6</id>
	<updated>2003-12-13T18:30:02Z</updated>


	<entry>
		<title>Atom-Powered Robots Run Amok</title>
		<link href="http://example.org/2003/12/13/atom03" />
		<link rel="alternate" type="text/html" href="http://example.org/2003/12/13/atom03.html"/>
		<link rel="edit" href="http://example.org/2003/12/13/atom03/edit"/>
		<id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
		<updated>2003-12-13T18:30:02Z</updated>
		<summary>Some text.</summary>
		<content type="xhtml">
			<div xmlns="http://www.w3.org/1999/xhtml">
				<p>This is the entry content.</p>
			</div>
		</content>
		<author>
			<name>John Doe</name>
			<email>johndoe@example.com</email>
		</author>
	</entry>

</feed>'

atom <- as_xml_document(atom)
ns <- xml_ns_rename(xml_ns(atom), d1 = "atom")

# real-life example of atom feed from https://www.theregister.co.uk/science/headlines.atom
atom_real <- '<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
  <id>tag:theregister.co.uk,2005:feed/theregister.co.uk/science/</id>
  <title>The Register - Science</title>
  <link rel="self" type="application/atom+xml" href="https://www.theregister.co.uk/science/headlines.atom"/>
  <link rel="alternate" type="text/html" href="https://www.theregister.co.uk/science/"/>
  <rights>Copyright Â© 2019, Situation Publishing</rights>
  <author>
    <name>Team Register</name>
    <email>webmaster@theregister.co.uk</email>
    <uri>https://www.theregister.co.uk/odds/about/contact/</uri>
  </author>
  <icon>https://www.theregister.co.uk/Design/graphics/icons/favicon.png</icon>
  <subtitle>Biting the hand that feeds IT â€” sci/tech news and views for the world</subtitle>
  <logo>https://www.theregister.co.uk/Design/graphics/Reg_default/The_Register_r.png</logo>
  <updated>2019-09-06T05:24:08Z</updated>
  <entry>
    <id>tag:theregister.co.uk,2005:story204682</id>
    <updated>2019-09-06T05:24:08Z</updated>
    <author>
      <name>Katyanna Quach</name>
      <uri>https://search.theregister.co.uk/?author=Katyanna%20Quach</uri>
    </author>
    <link rel="alternate" type="text/html" href="http://go.theregister.com/feed/www.theregister.co.uk/2019/09/06/boffins_proton_size/"/>
    <title type="html">Look, we know it feels like everythings going off the rails right now, but think positive: The proton has a new radius</title>
  <summary type="html" xml:base="http://www.theregister.co.uk/">&lt;h4&gt;0.833 femtometers also happens to be how close we are to losing our minds&lt;/h4&gt; &lt;p&gt;The positively charged proton sitting inside the nuclei of atoms has a radius smaller than a trillionth of a millimeter, according to a paper &lt;a target="_blank" rel="nofollow" href="https://science.sciencemag.org/content/365/6457/1007"&gt;published&lt;/a&gt; in Science on Thursday.â€¦&lt;/p&gt; &lt;p&gt;&lt;!--#include virtual="/data_centre/_whitepaper_textlinks_top.html" --&gt;&lt;/p&gt;</summary>
  </entry>
  <entry>
  <id>tag:theregister.co.uk,2005:story204657</id>
  <updated>2019-09-05T01:57:05Z</updated>
  <author>
  <name>Katyanna Quach</name>
  <uri>https://search.theregister.co.uk/?author=Katyanna%20Quach</uri>
  </author>
  <link rel="alternate" type="text/html" href="http://go.theregister.com/feed/www.theregister.co.uk/2019/09/05/new_york_meteor_mystery/"/>
  <title type="html">Big bang theory: Was mystery explosion over New York caused by a meteor? Dunno. By a military jet? Maybe...</title>
  <summary type="html" xml:base="http://www.theregister.co.uk/">&lt;h4&gt;US Space Command launches probe â€“ wait, is that the sound of a black helicopt&lt;/h4&gt; &lt;p&gt;A loud boom heard over the US state of New York on Labor Day could have been the result of a fireball arriving from space... or a military jet thundering through the skies... or something else, according to the American Meteor Society.â€¦&lt;/p&gt;</summary>
  </entry>
  </feed>
'

atom_real <- as_xml_document(atom_real)
ns_r <- xml_ns_rename(xml_ns(atom_real), d1 = "atom")

# atom feed with null fields
atom_null <- '<feed xmlns="http://www.w3.org/2005/Atom">

	<title></title>
	<subtitle></subtitle>
	<link />
	<link />
	<id></id>
	<updated></updated>


	<entry>
		<title></title>
		<link />
		<link />
		<link />
		<id></id>
		<updated></updated>
		<summary></summary>
		<content>
			<div>
				<p></p>
			</div>
		</content>
		<author>
			<name></name>
			<email></email>
		</author>
	</entry>

</feed>'

atom_null <- as_xml_document(atom_null)
ns_n <- xml_ns_rename(xml_ns(atom_null), d1 = "atom")

# atom feed with missing fields
atom_empty <- '<feed xmlns="http://www.w3.org/2005/Atom">

	<subtitle>""</subtitle>
	<link href="" rel="self"/>
	<link href=""/>
	<id>""</id>
	<updated>""</updated>


	<entry>
		<title>""</title>
		<link href="" rel="self"/>
		<link href=""/>
		<link href="" rel="alternate"/>
		<id>""</id>
		<updated>""</updated>
		<summary>""</summary>
		<content>
			<div>
				<p>""</p>
			</div>
		</content>
		<author>
			<name>""</name>
			<email>""</email>
		</author>
	</entry>

</feed>'

atom_empty <- as_xml_document(atom_empty)
ns_e <- xml_ns_rename(xml_ns(atom_empty), d1 = "atom")

