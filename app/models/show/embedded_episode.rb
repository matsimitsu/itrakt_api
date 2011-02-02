class Show::EmbeddedEpisode
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :show

  API_FIELDS = {
    :season_number => 'season_number',
    :episode_number => 'number',
    :name => 'name',
    :air_date => 'air_date',
    :tvdb_id => 'id'
  }

  field :season_number, :type => Integer
  field :episode_number, :type => Integer
  field :name
  field :air_date, :type => Date
  field :tvdb_id
  field :identifier
end