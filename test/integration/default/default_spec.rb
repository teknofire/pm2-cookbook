describe service('pm2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3000) do
  it { should be_listening }
end

describe command('PM2_HOME=/root/.pm2 pm2 show testing') do
  its('exit_status') { should eq 0 }
end
