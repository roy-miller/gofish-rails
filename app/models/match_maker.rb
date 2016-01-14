require 'pusher'
require 'timeout'

class MatchMaker
  attr_accessor :start_timeout_seconds, :pending_users

  def initialize
    @start_timeout_seconds = 6
  end

  def match(user, number_of_players)
    relevant_pending_users = pending_users[number_of_players]
    trigger_start_timer(number_of_players) if relevant_pending_users.empty?
    relevant_pending_users << user
    start_match_with(relevant_pending_users.shift(number_of_players)) if enough_users_for(number_of_players)
  end

  def pending_users
    @pending_users ||= Hash.new { |hash, key| hash[key] = [] }
  end

  private

  def enough_users_for(number_of_players)
    pending_users[number_of_players].count >= number_of_players
  end

  def start_match_with(users)
    match = Match.create(users: users)
    match.start
    MatchClientNotifier.new.observe_match(match)
    match.save!
    match
  end

  def trigger_start_timer(number_of_players, timeout_seconds=start_timeout_seconds)
    Thread.start {
      begin
        Timeout::timeout(timeout_seconds) {
          until enough_users_for(number_of_players)
          end
        }
      rescue Timeout::Error => e
        add_robots(number_of_players)
      end
    }
  end

  def add_robots(number_of_players)
    robots = []
    (number_of_players-1).times do |i|
      robot = RobotUser.create
      robot.save!
      robots << robot
    end
    a_match = nil
    robots.each { |robot| a_match = match(robot, number_of_players) }
    robots.each { |robot| robot.observe_match(a_match) }
    a_match.save!
    a_match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}",
                                               'match_start_event',
                                               { match_id: "#{a_match.id}" }) }

    # TODO the code above works, but it's messy; code below NEVER worked
    # a_match = nil
    # until a_match do
    #   robot = RobotUser.create
    #   robot.save!
    #   a_match = match(robot, number_of_players)
    #   robot.observe_match(a_match)
    #   a_match.save!
    # end
    #a_match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{a_match.id}/users/#{user.id}" }) }
    # a_match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { match_id: "#{a_match.id}" }) }
  end
end
