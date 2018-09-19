 domain_role = command("wmic computersystem get domainrole | Findstr /v DomainRole").stdout.strip

 ADMINISTRATORS_DOMAIN = attribute(
  'administrators_domain',
  description: 'List of authorized users in the local Administrators group',
  default: ["Admn",
            "Domain Admins",
            "Enterprise Admins"]
)

control "V-73219" do
  title "Only administrators responsible for the domain controller must have
  Administrator rights on the system."
  desc  "An account that does not have Administrator duties must not have
  Administrator rights. Such rights would allow the account to bypass or modify
  required security restrictions on that machine and make it vulnerable to attack.

  System administrators must log on to systems using only accounts with the
  minimum level of authority necessary.

  Standard user accounts must not be members of the built-in Administrators
  group.
  "
  if domain_role == '4' || domain_role == '5'
    impact 0.7
  else
    impact 0.0
  end
  tag "gtitle": "SRG-OS-000324-GPOS-00125"
  tag "gid": "V-73219"
  tag "rid": "SV-87871r1_rule"
  tag "stig_id": "WN16-DC-000010"
  tag "fix_id": "F-79665r1_fix"
  tag "cci": ["CCI-002235"] 
  tag "nist": ["AC-6 (10)", "Rev_4"]
  tag "nist": ["CCI-002235"]
  tag "documentable": false
  tag "check": "This applies to domain controllers. A separate version applies
  to other systems.

  Review the Administrators group. Only the appropriate administrator groups or
  accounts responsible for administration of the system may be members of the
  group.

  Standard user accounts must not be members of the local administrator group.

  If prohibited accounts are members of the local administrators group, this is a
  finding.

  If the built-in Administrator account or other required administrative accounts
  are found on the system, this is not a finding."
  tag "fix": "Configure the Administrators group to include only administrator
  groups or accounts that are responsible for the system.

  Remove any standard user accounts."
  administrator_group = command("net localgroup Administrators | Format-List | Findstr /V 'Alias Name Comment Members - command'").stdout.strip.split("\n")
  administrator_group.each do |user|
   a = user.strip
    describe "#{a}" do
      it { should be_in ADMINISTRATORS_DOMAIN}
    end  
  end  if domain_role == '4' || domain_role == '5'

  describe "System is not a domain controller, control not applicable" do
    skip "System is not a domain controller, control not applicable"
  end if domain_role != '4' && domain_role != '5'
end

