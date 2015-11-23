%Test Graph

%First Graph

edge(n1,n2).
edge(n1,n3).
edge(n1,n5).
edge(n1,n7).

edge(n2,n4).
edge(n2,n5).
edge(n2,n6).

edge(n3,n7).
edge(n3,n9).

edge(n4,n6).
edge(n4,n8).
edge(n4,n11).

edge(n5,n6).
edge(n5,n7).
edge(n5,n12).

edge(n6,n8).
edge(n6,n12).

edge(n7,n9).
edge(n7,n12).

edge(n8,n11).
edge(n8,n12).

edge(n9,n10).
edge(n9,n12).

edge(n10,n12).
edge(n10,n14).
edge(n10,n16).

edge(n11,n12).
edge(n11,n13).
edge(n11,n15).

edge(n12,n13).
edge(n12,n14).
edge(n12,n15).
edge(n12,n17).

edge(n13,n15).

edge(n14,n16).
edge(n14,n17).

edge(n15,n17).
edge(n15,n18).

edge(n16,n17).
edge(n16,n19).

edge(n17,n18).
edge(n17,n19).

edge(n18,n19).
edge(n18,n20).
edge(n18,n21).
edge(n18,n25).

edge(n19,n20).
edge(n19,n22).
edge(n19,n23).
edge(n19,n24).

edge(n20,n21).
edge(n20,n24).
edge(n20,n27).

edge(n21,n25).
edge(n21,n27).

edge(n22,n23).
edge(n22,n26).
edge(n22,n28).

edge(n23,n24).
edge(n23,n26).

edge(n24,n26).
edge(n24,n27).

edge(n25,n27).
edge(n25,n30).

edge(n26,n28).
edge(n26,n29).
edge(n26,n31).

edge(n27,n29).
edge(n27,n30).
edge(n27,n33).

edge(n28,n31).

edge(n29,n31).
edge(n29,n32).
edge(n29,n33).

edge(n30,n33).

edge(n31,n32).

edge(n32,n33).

%Second Graph

edge(n34,n35).
edge(n34,n36).
edge(n34,n38).
edge(n34,n40).

edge(n35,n37).
edge(n35,n38).
edge(n35,n39).

edge(n36,n40).
edge(n36,n42).

edge(n37,n39).
edge(n37,n41).
edge(n37,n44).

edge(n38,n39).
edge(n38,n40).
edge(n38,n45).

edge(n39,n41).
edge(n39,n45).

edge(n40,n42).
edge(n40,n45).

edge(n41,n44).
edge(n41,n45).

edge(n42,n43).
edge(n42,n45).

edge(n43,n45).
edge(n43,n47).
edge(n43,n49).

edge(n44,n45).
edge(n44,n46).
edge(n44,n48).

edge(n45,n46).
edge(n45,n47).
edge(n45,n48).
edge(n45,n50).

edge(n46,n48).

edge(n47,n49).
edge(n47,n50).

edge(n48,n50).
edge(n48,n51).

edge(n49,n50).
edge(n49,n52).

edge(n50,n51).
edge(n50,n52).

edge(n51,n52).
edge(n51,n53).
edge(n51,n54).
edge(n51,n58).

edge(n52,n53).
edge(n52,n55).
edge(n52,n56).
edge(n52,n57).

edge(n53,n54).
edge(n53,n57).
edge(n53,n60).

edge(n54,n58).
edge(n54,n60).

edge(n55,n56).
edge(n55,n59).
edge(n55,n61).

edge(n56,n57).
edge(n56,n59).

edge(n57,n59).
edge(n57,n60).

edge(n58,n60).
edge(n58,n63).

edge(n59,n61).
edge(n59,n62).
edge(n59,n64).

edge(n60,n62).
edge(n60,n63).
edge(n60,n66).

edge(n61,n64).

edge(n62,n64).
edge(n62,n65).
edge(n62,n66).

edge(n63,n66).

edge(n64,n65).

edge(n65,n66).

%Restrictions to this graph

%There must exist one list of Colours of each list wheels

:-assertz(listWheels([(n2,n35), (n14,n46), (n21,n55), (n22,n54), (n29,n62)])).
:-assertz(listWheels([(n3,n37), (n4,n36), (n13,n47), (n32,n65)])).
:-assertz(listColorsNumber([0,1,2,3,4,5])).
:-assertz(listColorsNumber([2,0,1,3,4,5])).
