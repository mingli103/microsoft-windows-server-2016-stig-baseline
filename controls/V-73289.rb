control 'V-73289' do
  title 'The Microsoft FTP service must not be installed unless required.'
  desc  "Unnecessary services increase the attack surface of a system. Some of
  these services may not support required levels of authentication or encryption."
  impact 0.5
  tag "gtitle": 'SRG-OS-000096-GPOS-00050'
  tag "gid": 'V-73289'
  tag "rid": 'SV-87941r1_rule'
  tag "stig_id": 'WN16-00-000360'
  tag "fix_id": 'F-79733r1_fix'
  tag "cci": ['CCI-000382']
  tag "nist": ['CM-7', 'Rev_4']
  tag "documentable": false
  desc "check", "If the server has the role of an FTP server, this is NA.

  Open PowerShell.

  Enter Get-WindowsFeature | Where Name -eq Web-Ftp-Service.

  If Installed State is Installed, this is a finding.

  An Installed State of Available or Removed is not a finding.

  If the system has the role of an FTP server, this must be documented with the
  ISSO."
  desc "fix", "Uninstall the FTP Server role.

  Start Server Manager.

  Select the server with the role.

  Scroll down to ROLES AND FEATURES in the right pane.

  Select Remove Roles and Features from the drop-down TASKS list.

  Select the appropriate server on the Server Selection page and click
  Next.

  Deselect FTP Server under Web Server (IIS) on the Roles page.

  Click Next and Remove as prompted."
  has_ftp_server_role = attribute('has_ftp_server_role')

  describe windows_feature('Web-Ftp-Service') do
    it { should_not be_installed }
  end
  if has_ftp_server_role == 'True'
    impact 0.0
    desc 'This server has the role of an FTP server, therefore this control is not applicable'
  end
end
