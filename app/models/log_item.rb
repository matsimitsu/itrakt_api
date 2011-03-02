class LogItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :source_name
  field :message
  field :data, :type => Hash, :default => {}
end
