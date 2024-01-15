// The Nick Shabazz Parametric Knife Display Stand
// Set the parameters below, and you're off
// All values below in millimeters
// Open this using OpenSCAD to modify or render - https://openscad.org/
// Nick Shabazz - 2024

// Length in mm (perpendicular to the knives)
blength=100;
// Width in mm (parallel to the knives)
bwidth=150;
// Thickness in mm of the base (8mm is reasonable)
bthiccness=8;
// Radius in mm at base of the base (10mm is reasonable)
bhullrad1=10;
// Radius in mm at top of the base (for tapering base, for untapered, make the same value as above) (6mm is reasonable)
bhullrad2=6;
// Increase in height from tier to tier in mm (sets the difference between each level of knife, as well as the height of the first layer) (25mm is reasonable)
handleheightdiff=25;
// Distance in mm between the top of the handle rest and the top of the blade rest (13mm is reasonable)
handletobladefall=13;
// Diameter of the handle rest in mm (25mm is reasonable)
handlediameter=25;
// Blade Notch Depth in mm (how deep the notch for the blade is) (8mm is reasonable)
bladenotchdepth=8;
// Blade Notch Width in mm (how wide the top of the notch for the blade is) (3mm is reasonable)
bladenotchwidth=3;
// Position of the supports in terms of width (e.g. 0.2 will put it at 20% and 80% of the width) of the base
supportpositionwidth=0.15;
// Width of the supports in mm (20mm is reasonable)
supportwidth=20;

// Number of knives
knifenum=2;

// Defines the length of each support piece in terms of the overall length of the base
supportlength=(0.8*blength)/knifenum;
// No need to modify this bit, it just defines the position of the supports parametrically
righthandlepos=(1-supportpositionwidth)*bwidth;
rightbladepos=supportpositionwidth*bwidth;
lefthandlepos=supportpositionwidth*bwidth;
leftbladepos=(1-supportpositionwidth)*bwidth;

// To put the handle on the left, change the below two statements to read 'lefthandlepos' and 'leftbladepos'
handlepos=lefthandlepos;
bladepos=leftbladepos;

// This creates the base with rounded edges
module baseshapehull(length, width, thiccness, hullrad1, hullrad2) {
    difference() {
    hull(){
        // Creates a hull around four tapered cylinders
     translate([hullrad1,hullrad1,0]){cylinder(thiccness,hullrad1,hullrad2);};
     translate([length-hullrad1,width-hullrad1,0]){cylinder(thiccness,hullrad1,hullrad2);};
     translate([hullrad1,width-hullrad1,0]){cylinder(thiccness,hullrad1,hullrad2);};
     translate([length-hullrad1,hullrad1,0]){cylinder(thiccness,hullrad1,hullrad2);};
            };
            // Comment out the next line to print a solid base, without the hole
     translate([length*0.15,width*0.25,-10]) {cube([length*0.7, bwidth*0.5, 100]);};
 };};
// This creates a holder with a round cutout for handles           
module handleholder(supportlength, supportwidth, height, handlediameter) {
    toplength=(handlediameter*1.1);
    taperpercent=toplength/supportlength;
    difference() {
        linear_extrude(height = height, twist = 0, scale = taperpercent, slices = 200)
            square([supportwidth,supportlength], center=true);
        translate([0,0,height+0.1*handlediameter])rotate([0,90,0])cylinder(h=100,d=handlediameter, center=true);

    }
}
// This creates a holder with a notched cutout for blades
module bladeholder(supportlength, supportwidth, height, bladenotchdepth,bladenotchwidth, handlediameter) {
    toplength=(bladenotchwidth*2);
    taperpercent=toplength/supportlength;

    difference() {
        linear_extrude(height = height, twist = 0, scale = taperpercent, slices = 200) square([supportlength, supportwidth], center=true);
        translate([0,0,height+0.1*bladenotchdepth])rotate([0,180,0])linear_extrude(height = bladenotchdepth, twist = 0, scale = 0.5, slices = 200)
            square([bladenotchwidth,1000], center=true);

    }
}

//If you'd like to make a sword holder with just blades, then replace the two handle-holders with blade holders.
// Similarly, this makes a pen holder if you change the handletobladefall and then replace with two handleholders
baselengthoffset=blength/(1+knifenum);
union(){
    for (knifeid=[1:knifenum]){
        knifeoffset=knifeid*baselengthoffset;
        knifeheight=(knifeid*handleheightdiff);
        bladeheight=knifeheight-handletobladefall;
translate([knifeoffset,handlepos,bthiccness])rotate([0,0,90])handleholder(supportlength,supportwidth,knifeheight,handlediameter);
        translate([knifeoffset,bladepos,bthiccness])rotate([0,0,0])bladeholder(supportlength,supportwidth,bladeheight,bladenotchdepth,bladenotchwidth, handlediameter);
    };
    baseshapehull(blength,bwidth,bthiccness,bhullrad1,bhullrad2);
};