// Screen clamp for Mercedes-Benz A class 2012
// 31-07-2022

$fn = 50;

screen_mount_w = 145;
screen_mount_h = 53.5;

clamp_w = 6;
clamp_opennes = .90;
clamp_opennes_h = .80;

panel_roundness = 6;
panel_w = 38-clamp_w;
panel_h = 65;

top_r = panel_h/4;
bottom_r = 10;

qlock_clamp_diff = 49;
qlock_clamp_d = 5;

conn_pin_r = 10;
conn_place_h = 10;
conn_place_w = 53;

clamp_thickness = 2;
panel_thickness = 5;
top_bar_thickness = 5;

nut_h = 5;
nut_space = 3;
nut_dia = 9.3;
nut_bolt_dia = 5;

module screen_place() {
    square([screen_mount_w, screen_mount_h], center = true);
}

module top_bar() {
    translate([clamp_w, screen_mount_h/2+clamp_w+5/2+2,0]) offset(r = clamp_w)
        square([screen_mount_w+clamp_w*2+10, 1], center = true);
}

module clamp() union() {
    difference() {
        offset(r = clamp_w) square([screen_mount_w, screen_mount_h], center = true);
        screen_place();
        translate([0,-screen_mount_h/2,0]) square([screen_mount_w * clamp_opennes, screen_mount_h], center = true);
        translate([-screen_mount_w/2,0,0]) square([screen_mount_w, screen_mount_h * clamp_opennes_h], center = true);
        translate([-screen_mount_w/2,-screen_mount_h/2,0]) screen_place();
    }
    translate([screen_mount_w*clamp_opennes/2, -(screen_mount_h+clamp_w)/2,0]) circle(d = clamp_w);
    translate([-(screen_mount_w+clamp_w)/2, (screen_mount_h*clamp_opennes_h)/2,0]) circle(d = clamp_w);
    
    translate([clamp_w, screen_mount_h/2+clamp_w+5/2,0]) offset(r = clamp_w) square([screen_mount_w+clamp_w*2+10, 5], center = true);

    translate([-screen_mount_w/2-clamp_w,screen_mount_h/2+2*clamp_w + 5,0]) difference() {
        circle(15);
        circle(10);
    }
}

module holes() {
    circle(d = qlock_clamp_d);
    translate([0,-qlock_clamp_diff,0]) circle(d = qlock_clamp_d);
}

module holes_line() {
    holes();
    translate([-10,0,0]) holes();
    translate([-20,0,0]) holes();
    translate([-30,0,0]) holes();
    translate([-40,0,0]) holes();
}

module panel_old() {
    difference() {
        translate([screen_mount_w/2  + panel_roundness, 0,0]) offset(r = panel_roundness) square([panel_w,panel_h], center = false);
        /*translate([screen_mount_w/2 + clamp_w + panel_w,panel_h,0]) {
            holes_line();
            translate([0,-10,0]) holes_line();
        }
        */
    }
}

module panel() {
    difference() {
        translate([screen_mount_w/2  + panel_roundness + clamp_w, -screen_mount_h/2,0]) offset(r = panel_roundness) square([panel_w,panel_h], center = false);
    }
}

module panel_strengther() {
    cut_h=3;
    translate([-screen_mount_w/2-panel_w/2-12,10,-panel_w*5/2+cut_h+panel_thickness]) difference() {
        sphere(d = panel_w*5);
        translate([0,0,-cut_h]) cube(panel_w*5, center=true);
    }
}

module top_transition() {
    translate([screen_mount_w/2-top_r,screen_mount_h/2+clamp_w,0]) difference() {
        square(top_r);
        translate([0,top_r,0]) circle(r = top_r);
    }
}

module bottom_transition() {
    translate([screen_mount_w/2+clamp_w,-panel_roundness-bottom_r,0]) difference() {
        square(bottom_r);
        translate([bottom_r,0,0]) circle(r = bottom_r);
    }
}

module conn_pins() {
    for (i = [0 : 10 : 350]) {
        rotate(i) translate([conn_pin_r,0,0]) circle(d = 1);
    }
}

module conn_circle() {
    circle(d = 14);
}

module conn_base() {
    circle(d = 25);
}

module nut() {
    polygon([for (i = [0 : 60 : 360] )
        [sin(i) * nut_dia/2, cos(i) * nut_dia/2]
    ]);
}

module nut_space() {
    translate([0,0,-50])linear_extrude(height=100) circle(d = nut_bolt_dia);

    union() {
        cyl_h = 1;
        translate([0,0,-nut_h+clamp_thickness]) linear_extrude(height=nut_h-cyl_h+clamp_thickness) nut();
        translate([0,0,-nut_h+clamp_thickness/2]) cylinder(h=cyl_h, d1=nut_bolt_dia, d2=nut_dia, center = false);
    }
}

module conn() {
    translate([0,0,-nut_h-nut_space+clamp_thickness-0.5]) linear_extrude(height=1) conn_pins();
    
    difference() {
    translate([0,0,-nut_h-nut_space+clamp_thickness]) linear_extrude(height=nut_h+nut_space) conn_base();
    
    translate([0,0,-nut_h-nut_space+clamp_thickness-1.0-8]) linear_extrude(height=10) conn_circle();
    }
}

module slip() {
    translate([-160,26,-46]) rotate([5,15,0]) cube(50);
}

module slip2() {
    translate([-218.2,-73.5,-56]) rotate([0,35,0]) cube(100);
}

module slip3() {
    translate([-screen_mount_w/2-clamp_w-100,-113.5,-60]) rotate([35,0,0]) cube(100);
}

module main() {
    difference() {
        rotate([0,180,0]) difference() {
            union() {
                linear_extrude(height=clamp_thickness) {
                    clamp();
                    //top_transition();
                    //bottom_transition();
                }
                translate([0,0,-top_bar_thickness]) linear_extrude(height=top_bar_thickness) top_bar();
                translate([0,0,-panel_thickness]) linear_extrude(height=panel_thickness+clamp_thickness) panel();

                translate([screen_mount_w/2 - conn_pin_r +conn_place_w, screen_mount_h/2+conn_place_h,0]) conn();
            }
            translate([screen_mount_w/2 - conn_pin_r + conn_place_w, screen_mount_h/2+conn_place_h,0]) nut_space();
        }

        slip();
        slip2();
        slip3();
    }
    panel_strengther();
}

difference() {
    main();
    
    // translate([-150,36,-10]) cube(100); // to check nut cut internals: get this diff
}