package TieOut;

sub TIEHANDLE {
	bless( \(my $scalar), $_[0]);
}

sub PRINT {
	my $self = shift;
	$$self .= join('', @_);
}

sub PRINTF {
	my $self = shift;
    my $fmt  = shift;
	$$self .= sprintf $fmt, @_;
}

sub read {
	my $self = shift;
    my $data = $$self;
    $$self = '';
	return $data;
}

1;
