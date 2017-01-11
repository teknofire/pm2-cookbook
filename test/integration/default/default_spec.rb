describe service('pm2') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3000) do
  it { should be_listening }
end
