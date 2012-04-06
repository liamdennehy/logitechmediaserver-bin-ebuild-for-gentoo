# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# This file contains a custom OS package to provide information on the
# installation structure on Gentoo.

package Slim::Utils::OS::Custom;

use strict;

use base qw(Slim::Utils::OS::Linux);

sub initDetails {
	my $class = shift;

	$class->{osDetails} = $class->SUPER::initDetails();

	$class->{osDetails}->{isGentoo} = 1 ;

	# Ensure we find manually installed plugin files.
	push @INC, '/var/lib/logitechmediaserver';
	push @INC, '/var/lib/logitechmediaserver/Plugins';

	return $class->{osDetails};
}

=head2 dirsFor( $dir )

Return OS Specific directories.

Argument $dir is a string to indicate which of the Logitech Media Server
directories we need information for.

=cut

sub dirsFor {
	my ($class, $dir) = @_;

	my @dirs = ();

	if ($dir eq 'Plugins') {

		# User-installed plugins are in a different place.
		push @dirs, '/var/lib/logitechmediaserver/Plugins';

	} elsif ($dir =~ /^(?:prefs)$/) {

		# Server and plugin preferences are in a different place.
		push @dirs, $::prefsdir || '/etc/logitechmediaserver';

	} else {
	
		# Use the default behaviour to locate the directory.
		push @dirs, $class->SUPER::dirsFor($dir);

	}

	return wantarray() ? @dirs : $dirs[0];
}

1;

__END__
