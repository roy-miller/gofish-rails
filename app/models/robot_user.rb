require 'match'
require 'user'

class RobotUser < User
  attr_accessor :think_time
  attr_reader :match
  after_initialize :set_defaults
  after_create :set_name

  def set_defaults
    self.name ||= "robot"
    @think_time ||= 2.5
  end

  def set_name
    update_attribute(:name, "robot#{self.id}")
  end

  def observe_match(match)
    match.add_observer(self)
  end

  def update(*args)
    @match = args.first
    make_request(match) if (match.current_player == self)
  end

  def make_request(match)
    contemplate_before {
      match.ask_for_cards(requestor: self, recipient: pick_opponent, card_rank: pick_rank)
      match.save!
    }
  end

  def player
    match.player_for(self)
  end

  protected

  def opponents
    match.opponents_for(self)
  end

  def pick_opponent
    opponents.sample
  end

  def pick_rank
    player.hand.sample.rank
  end

  def contemplate_before
    if self.think_time > 0
      Thread.start do
        sleep(self.think_time)
        yield
      end
    else
      yield
    end
  end
end
