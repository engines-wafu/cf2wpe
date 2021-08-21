clear; pkg load io; format long;

# Read input filename and check it exists the parse coordinates.

input_file = input("Input filename:\n", "s");

if input_file != 2
  printf ("Not a valid file\n");
  printf ("Assuming default filename\n");
  input_file = "navaids.dat";
endif

coords = dlmread (input_file, ";", "B2:C78" );
finger = strtrunc (hash ("md5", input_file), 4);

# Create waypoint objects.

wpe = [];
i = 1;
n = length(coords);

for i = 1:n
  wpe.waypoints(i).number = i;
  wpe.waypoints(i).elevation = 0;
  wpe.waypoints(i).name = i;
  #wpe.waypoints(i).sequence = "0";
  wpe.waypoints(i).wp_type = "WP";
  wpe.waypoints(i).latitude = coords(i,1);
  wpe.waypoints(i).longitude = coords(i,2);
endfor

wpe.name = strcat ("CF_to_WE-", datestr(date(),"yyyymmdd"), "-", finger);
wpe.aircraft = "harrier";

# Write output file.

output_file = input("Output filename:\n", "s");

if output_file != 2
  printf ("Not a valid file\n");
  printf ("Assuming default filename\n");
  output_file = strcat (wpe.name, ".json");
endif

fid = fopen (output_file, "w");
fputs (fid, toJSON (wpe));
fclose (fid);