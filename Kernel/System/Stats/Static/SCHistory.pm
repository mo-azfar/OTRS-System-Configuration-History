#For static stats. Generate stats regarding System Configuration changes.
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
###OTRS 6 API REFERENCE: https://doc.otrs.com/doc/api/otrs/6.0/Perl/index.html

package Kernel::System::Stats::Static::SCHistory;
## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

use strict;
use warnings;
use List::Util qw( first );

#use Kernel::System::VariableCheck qw(:all);
#use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
	'Kernel::Config',
    'Kernel::Language',
    'Kernel::System::DB',
);

sub new {
    my ( $Type, %Param ) = @_;

    ### allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );
	
	
	return $Self;
}

sub GetObjectBehaviours {
    my ( $Self, %Param ) = @_;

    my %Behaviours = (
        ProvidesDashboardWidget => 0,
    );

    return %Behaviours;
}

sub Param {
    my $Self = shift;

    my @Params = ();
	
	my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
	
	push @Params, {
        Frontend   => 'Report Type',
        Name       => 'ReportType',
        Multiple   => 0,
        Size       => 0,
        SelectedID => 1,
        Data       => {
            1 => 'Latest Changes (Unique)',
			2 => 'Overall Changes',
        },
    };
	
    return @Params;
		
}

sub Run {
   my ( $Self, %Param ) = @_;

	my $ReportType =  $Param{ReportType};
	
	my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

	my $SQL;
	
	if ($ReportType eq 1)
	{
		#Latest changes (unique name)
		$SQL="SELECT 
		sm.NAME, 
		sm.effective_value AS MODIFIED_VALUE, 
		sd.effective_value AS DEFAULT_VALUE,
		sm.change_time AS MODIFIED_TIME, 
		CONCAT_WS(' ', u.first_name, u.last_name) AS MODIFIED_BY 
		FROM sysconfig_modified sm
		JOIN sysconfig_default sd ON (sm.sysconfig_default_id=sd.id)
		JOIN users u ON (sm.change_by=u.id)";
	}
	elsif ($ReportType eq 2)	
	{
		#Overall changes
		$SQL="SELECT 
		smv.name, 
		smv.effective_value AS MODIFIED_VALUE, 
		sdv.effective_value AS DEFAULT_VALUE,
		smv.change_time AS MODIFIED_TIME, 
		CONCAT_WS(' ', u.first_name, u.last_name) AS MODIFIED_BY 
		FROM sysconfig_modified_version smv
		JOIN sysconfig_default_version sdv ON (smv.sysconfig_default_version_id=sdv.id)
		JOIN users u ON (smv.change_by=u.id)
		ORDER BY smv.name";
	}
	
	
	$DBObject->Prepare(
        SQL    => $SQL,
        #Bind   => [ \$StartDate, \$EndDate ],
    );
	
  my $Title = "System Configuration History";
	my @HeadData = $DBObject->GetColumnNames();
	
	my @Data;
	while ( my @Row = $DBObject->FetchrowArray() ) 
	{
		push @Data, \@Row;
    }
	
	return ( [$Title], [@HeadData], @Data );
		
}

1;
