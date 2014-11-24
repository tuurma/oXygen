#TEICEToolbox - TEI Critical Edition Toolbox#
  
## TEI Critical Edition Toolbox [http://ciham-digital.huma-num.fr/teitoolbox/]##

TEI Checker (working title) addition to oXygen framework packages Marjorie Burghart's on-line tool that offers facilities to visualize critical edition while it is still in the making, and check the consistency of the encoding.

The TEI Critical Edition Toolbox can help to check editions encoded in TEI with the parallel-segmentation method. If using a "positive" apparatus, listing all the readings of all the manuscripts in the @wit attributes of the <lem/> and/or <rdg/>, the application will be able to detect all apparatus entries that do not use all the witnesses listed in a <listWit/> in the header. 

The part of the existing tool that dealt with downloading and transformation of the file (originally in php) has been rewritten as ANT transformation script and everything wrapped into an oXygen action to seamlessly work in oXygen environment.