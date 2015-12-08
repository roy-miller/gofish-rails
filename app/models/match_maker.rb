require 'pusher'
require 'timeout'

class MatchMaker
  attr_accessor :start_timeout_seconds, :pending_users

  def initialize
    @start_timeout_seconds = 5
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
    match = Match.create(users: users) # TODO need match.id (save #1)
    match.start
    MatchClientNotifier.new.observe_match(match)
    Rails.logger.debug("match started:\n#{match}")
    begin
      binding.pry
      match.save! # TODO AND have to save observers for robot match (save #2)
    rescue StandardError => e
      Rails.logger.debug("\n*****start_match_with, ERROR SAVING MATCH:\n#{e.message}*****\n")
    end
    Rails.logger.debug("match saved")
    match
  end

  def trigger_start_timer(number_of_players, timeout_seconds=start_timeout_seconds)
    Thread.start {
      begin
        Timeout::timeout(timeout_seconds) {
          until enough_users_for(number_of_players)
            # better way to wait?
          end
        }
      rescue Timeout::Error => e
        add_robots(number_of_players)
      end
    }
  end

  def add_robots(number_of_players)
    a_match = nil
    until a_match do
      robot = RobotUser.create
      #robot.name = "robot1"
      #robot.email = "robot1@rolemodelsoft.com"
      #robot.password = "robot1password"
      Rails.logger.debug("\n*****CREATED ROBOT: #{robot.inspect}*****\n")
      begin
        robot.save!(validate: false)
      rescue StandardError => e
        Rails.logger.debug("\n*****ERROR SAVING ROBOT: #{e.message}*****\n")
      end
      Rails.logger.debug("\n*****SAVED ROBOT*****\n")
      a_match = match(robot, number_of_players)
      robot.observe_match(a_match)
      Rails.logger.debug("\n*****SAVING MATCH*****\n")
      begin
        a_match.save!
      rescue StandardError => e
        Rails.logger.debug("\n*****ERROR SAVING MATCH: #{e.message}*****\n")
      end
      Rails.logger.debug("\n*****SAVED MATCH*****\n")
    end
    a_match.users.each { |user| Pusher.trigger("wait_channel_#{user.id}", 'match_start_event', { message: "/matches/#{a_match.id}/users/#{user.id}" }) }
  end
end
