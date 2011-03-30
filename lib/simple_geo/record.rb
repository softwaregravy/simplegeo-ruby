module SimpleGeo
  class Record
    attr_accessor :layer, :id, :lat, :lon, :type, :created, :properties, :distance

    def initialize(options={})
      options = {
        :created => Time.now,
        :type => 'object',
        :properties => {}
      }.merge(options)

      @id = options[:id]
      @layer = options[:layer]
      @type = options[:type]
      @lat = options[:lat]
      @lon = options[:lon]
      @created = options[:created]
      @properties = options[:properties]
      @distance = options[:distance]
    end

    def to_hash
      {
        :type => 'Feature',
        :id => id,
        :created => created.to_i,
        :geometry => {
          :type => 'Point',
          :coordinates => [ lon, lat ]
        },
        :properties => properties.merge({
          :type => type
        })
      }
    end

    def to_json
      self.to_hash.to_json
    end

    def ==(other)
      other.class == self.class && self.to_hash == other.to_hash
    end

    def self.parse_geojson_hash(json_hash)
      Record.new(
        :id => json_hash['id'],
        :type => json_hash['properties'].delete('type'),
        :lat => json_hash['geometry']['coordinates'][1],
        :lon => json_hash['geometry']['coordinates'][0],
        :distance => json_hash.has_key?('distance') ? json_hash['distance'] : 0,
        :properties => HashUtils.recursively_symbolize_keys(json_hash['properties'])
      )
    end

  end
end
