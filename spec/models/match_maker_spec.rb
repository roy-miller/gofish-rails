describe MatchMaker do
  let(:match_maker) { MatchMaker.new }
  let(:user) { build(:real_user) }
  let(:another_user) { build(:real_user) }

  before do
    allow(match_maker).to receive(:trigger_start_timer).with(any_args).and_return(nil)
  end

  it 'does not make a match when it does not have the right number of users' do
    expect(match_maker.match(user, 2)).to be_nil
  end

  it 'makes a match when it has the right number of users' do
    allow_any_instance_of(Match).to receive(:save!).and_return(nil)
    match_maker.match(user, 2)
    match = match_maker.match(another_user, 2)
    expect(match).not_to be_nil
    expect(match.users).to contain_exactly(user, another_user)
  end

  it 'starts a match with robots if not enough users join in time' do
    match_maker.start_timeout_seconds = 0
    match_maker.match(user, 2)
    expect(match_maker).to have_received(:trigger_start_timer).once
  end

  it 'makes a second match when it has the right number of users' do
    2.times { match_maker.match(build(:real_user), 2) }
    match_maker.match(user, 2)
    match = match_maker.match(another_user, 2)
    expect(match.users).to contain_exactly(user, another_user)
  end

  it 'does not match users wanting different number of opponents' do
    match_maker.match(user, 3)
    match = match_maker.match(another_user, 2)
    expect(match).to be_nil
  end
end
