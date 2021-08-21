clear; pkg load io; format long;

# Read input filename and check it exists the parse coordinates.

input_file = input("Input filename:\n", "s");

if exist (input_file) != 2;
  if exist ("navaids.dat") == 2;
    printf ("Invalid file, instad using defaul navaids.dat\n");
    input_file = "navaids.dat";
  else
  printf ("No vaild file available, copy navaids.dat to this directory or check the filename spelling.\n\n");
  return;
  endif
endif

coords = dlmread (input_file, ";", "B3:C78" );
starting = dlmread (input_file, ";", "B2:C2" );
finger = strtrunc (hash ("md5", mat2str ([coords; starting])), 4);

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
  wpe.waypoints(i).latitude = coords(i,2);
  wpe.waypoints(i).longitude = coords(i,1);
endfor

wpe.waypoints(n+1).number = n+1;
wpe.waypoints(n+1).elevation = 0;
wpe.waypoints(n+1).name = "START";
#wpe.waypoints(n+1).sequence = "0";
wpe.waypoints(n+1).wp_type = "WP";
wpe.waypoints(n+1).latitude = starting(1,2);
wpe.waypoints(n+1).longitude = starting(1,1);

wpe.name = strcat ("cf2wpe-", datestr(date(),"yyyymmdd"), "-", finger);
wpe.aircraft = "harrier";

# Write output file.

output_file = strcat (wpe.name, ".json");

fid = fopen (output_file, "w");
fputs (fid, toJSON (wpe));
fclose (fid);