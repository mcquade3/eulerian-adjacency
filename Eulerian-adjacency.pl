#!/usr/local/bin/perl
# Mike McQuade
# Eulerian-adjacency.pl
# Finds the Eulerian path for a directed graph given an adjacency list.

# Define the packages to use
use strict;
use warnings;

# Initialize variables
my (@lines,%graph,%visited);

# Open the file to read
open(my $fh,"<ba3g.txt") or die $!;

# Read in the values from the file and put them into a hash
while (my $line = <$fh>) {
	chomp($line);
	my @edges = split(/ -> /,$line);
	my @list = split(/,/,$edges[1]);
	$graph{$edges[0]} = [@list];
}

# Iterate through the hash to find a path that has the same number
# of edges as the total number in the graph.
my $maxLength = 0;
my @eurlerian;
foreach my $key (keys %graph) {
    my @temp = depthFirstTraversal($key);
    if (scalar @temp > $maxLength) {
        $maxLength = scalar @temp;
        @eurlerian = @temp;
    }
}

# Print out the longest path for the graph,
# which should be the Eulerian Path.
print join("->",@eurlerian)."\n";

# Close the file
close($fh) || die "Couldn't close file properly";



# Define the recursive function used to traverse the graph.
sub depthFirstTraversal {
    # Initialize parameter
    my $v = $_[0];

    # Make sure the key has a hash to traverse
    if ($graph{$v}) {
        # If there is only one outgoing edge, traverse that edge
        if (scalar keys $graph{$v} == 1) {
            my $edge = $graph{$v}[0];
            if (!$visited{$v}) {
                $visited{$v}[0] = $edge;
                return ($v,depthFirstTraversal($edge));
            }
        # If there are multiple edges to traverse, then call the
        # multitraversal function to find the optimal path.
        } else {
            return ($v,multiTraversal($v));
        }
    } else {
        return; #base case
    }
}

# Define the function to be used when there are multiple branches to traverse
sub multiTraversal {
    # Initialize parameter
    my $v = $_[0];

    # Traverse each outgoing edge from the given node to find the
    # optimal path that passes through all the edges of the graph.
    my @paths;
    foreach my $edge (values $graph{$v}) {
        if ($visited{$v}) {
            if (grep {$_ != $edge} $visited{$v}) {
                my @arr = depthFirstTraversal($edge);
                push @paths,[@arr];
            }
        } else {
            my @arr = depthFirstTraversal($edge);
            push @paths,[@arr];
        }
    }

    # Iterate through the found paths to find the longest one
    my $max = 0;
    my $index = 0;
    for (my $i = 0; $i < scalar(@paths); $i++) {
        if (scalar $paths[$i] > $max) {
            $max = scalar $paths[$i];
            $index = $i;
        }
    }

    # Return the path with the largest number of elements found in it.
    return $paths[$index];
}