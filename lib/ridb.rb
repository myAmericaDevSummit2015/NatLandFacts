module RIDB
  # A set of client classes for new RIDB API
  # https://ridb.recreation.gov/api/v1
  # http://ridb-dev.nsitellc.com/docs/api/v1/

  # Usage:
  # > $ridb = RIDB::Client.new(ENV['RIDB_API_KEY'], debug: true)

  # Returns a list of organization items
  # > $ridb.organizations.list.items

  # Get the meta data (paging info) for a list of of organizations
  # > $ridb.organizations.list.meta

  # Get a specific organization by id
  # > $ridb.organizations.get(123)

  # Returns a list of recreation areas for the first organization
  # > $ridb.oragnizations.list.items.first.recareas.list

  # Available Resources:
  # * organizations
  # * recreation_areas
  # * recreation_areas_by_state
  # * recreation_area_addresses
  # * facilities
  # * facility_addresses
  # * campsites
  # * permit_entrances
  # * tours
  # * activities
  # * events
  # * media
  # * links

  class Convert
    def self.facilities_to_geojson(path='Facilities_API_v1.json')
      data = JSON.load(File.open(path,'r').read.force_encoding("ISO-8859-1").encode("UTF-8"))
      features = data['RECDATA'].map do |item|
        feature = {
          type: 'Feature',
          properties: item,
          geometry: {
            type: 'Point',
            coordinates: [item['FacilityLongitude'],item['FacilityLatitude']]
          }
        }
      end
      geojson = {
        type: "FeatureCollection",
        features: features
      }
      return geojson
    end

    def self.save_facilities_to_geojson(input="Facilities_API_v1.json",output="Facilities_API_v1.geojson")
      File.open(output,'w').write(JSON.dump(facilities_to_geojson(input)))
    end

    def self.permitentrances_to_geojson(path='PermitEntrances_API_v1.json')
      data = JSON.load(File.open(path,'r').read.force_encoding("ISO-8859-1").encode("UTF-8"))
      features = data['RECDATA'].map do |item|
        feature = {
          type: 'Feature',
          properties: item,
          geometry: {
            type: 'Point',
            coordinates: [item['Longitude'],item['Latitude']]
          }
        }
      end
      geojson = {
        type: "FeatureCollection",
        features: features
      }
      return geojson
    end

    def self.save_permitentrances_to_geojson(input="PermitEntrances_API_v1.geojson",output="PermitEntrances_API_v1.geojson")
      File.open(output,'w').write(JSON.dump(permitentraces_to_geojson))
    end

    def self.recareas_to_geojson(path='RecAreas_API_v1.json')
      data = JSON.load(File.open(path,'r').read.force_encoding("ISO-8859-1").encode("UTF-8"))
      features = data['RECDATA'].map do |item|
        feature = {
          type: 'Feature',
          properties: item,
          geometry: {
            type: 'Point',
            coordinates: [item['RecAreaLongitude'],item['RecAreaLatitude']]
          }
        }
      end
      geojson = {
        type: "FeatureCollection",
        features: features
      }
      return geojson
    end

    def self.save_recareas_to_geojson(input="RecAreas_API_v1.geojson",output="RecAreas_API_v1.geojson")
      File.open(output,'w').write(JSON.dump(permitentraces_to_geojson))
    end

  end

  class Client

    attr_accessor :last_url
    attr_accessor :last_response

    def initialize(apikey,opts={})
      opts.reverse_merge!({
        base_url: "https://ridb.recreation.gov/api/v1",
        debug: false
      })
      @base_url = opts[:base_url]
      @debug = opts[:debug]
      @conn = Faraday.new
      @apikey = apikey
    end

    def auth_headers
      {'apikey' => "#{@apikey}"}
    end

    def get(endpoint,opts={})
      url = "#{@base_url}/#{endpoint}"
      self.last_url = url
      response = @conn.get url, opts, auth_headers
      self.last_response = response
      if @debug
        puts "URL >>>"
        puts url
        puts "RESPONSE >>>"
        puts response.body
      end
      response
    end

    def organizations
      @_organizations ||= Resource.new(self,'organizations','OrgID')
    end

    def recreation_areas
      @_recareas ||= Resource.new(self,'recareas','RecAreaID')
    end

    def recreation_areas_by_state(state)
      @_recareas ||= Resource.new(self,"recareas?state=#{state}",'RecAreaID')
    end

    def recreation_area_addresses
      @_recarea_addresses ||= Resource.new(self,'recareaaddresses','RecAreaAddressID')
    end

    def facilities
      @_facilities ||= Resource.new(self,'facilities','FacilityID')
    end

    def facility_addresses
      @_facilities ||= Resource.new(self,'facilityaddresses','FacilityAddressID')
    end

    def campsites
      @_campsites ||= Resource.new(self,'campsites','CampsiteID')
    end

    def permit_entrances
      @_permit_entrances ||= Resource.new(self,'permitentrances','PermitEntranceID')
    end

    def tours
      @_tours ||= Resource.new(self,'tours','TourID')
    end

    def activities
      @_activities ||= Resource.new(self,'activities','ActivityID')
    end

    def events
      @_events ||= Resource.new(self,'events','EventID')
    end

    def media
      @_media ||= Resource.new(self,'media','MediaID')
    end

    def links
      @_links ||= Resource.new(self,'links','LinkID')
    end

    def resources
      @_resources ||= [
        :organizations,
        :recreation_areas,
        :recreation_area_addresses,
        :facilities,
        :facility_addresses,
        :campsites,
        :permit_entrances,
        :tours,
        :activities,
        :events,
        :media,
        :links
      ]
    end

  end

  class Resource
    attr_accessor :name
    attr_accessor :id_field
    attr_accessor :parent_item
    attr_accessor :client

    def initialize(client,name,id_field,parent_item=nil)
      self.parent_item
      self.name = name
      self.client = client
      self.id_field = id_field
      @prefix = ""
      @prefix = "#{parent_item.resource.name}/#{parent_item.id}/" if parent_item
    end

    def list(opts={})
      opts.reverse_merge! offset: 0, limit: 50, query:''
      response = JSON.load(client.get("#{@prefix}#{name}",opts).body)
      items = response['RECDATA'].map do |i|
        if i.is_a?(Array)
          Item.new(self,i[0])
        else
          Item.new(self,i)
        end
      end
      ListResults.new(
        response['METADATA'],
        items
      )
    end

    def get(id)
      response = JSON.load(client.get("#{name}/#{id}").body)
      Item.new(self,response[0])
    end

    def page(index=0)
      list(offset: index*50)
    end

  end

  class ListResults
    attr_accessor :meta
    attr_accessor :items

    def initialize(meta,items)
      self.meta = meta
      self.items = items
    end

    def current_count
      meta['RESULTS']['CURRENT_COUNT']
    end

    def last_page?
      (current_count > 0) && (current_count < 50)
    end

    def more_pages?
      current_count == 50
    end

    def pluck(key)
      items.map{|i|i.data[key]}
    end

    def keys
      items.first.data.keys
    end

  end

  class Item
    attr_accessor :resource
    attr_accessor :data

    def initialize(resource,data)
      self.resource = resource
      self.data = data
    end

    def id
      data[resource.id_field]
    end

    def recreation_areas
      @_recareas ||= Resource.new(resource.client,'recareas','RecAreaID',self)
    end

    def facilities
      @_facilities ||= Resource.new(resource.client,'facilities','FacilityID',self)
    end

    def campsites
      @_campsites ||= Resource.new(resource.client,'campsites','CampsiteID',self)
    end

    def permit_entrances
      @_permit_entrances ||= Resource.new(resource.client,'permitentrances','PermitEntranceID',self)
    end

    def tours
      @_tours ||= Resource.new(resource.client,'tours','TourID',self)
    end

    def activities
      @_activities ||= Resource.new(resource.client,'activities','ActivityID',self)
    end

    def events
      @_events ||= Resource.new(resource.client,'events','EventID',self)
    end

    def media
      @_media ||= Resource.new(resource.client,'media','MediaID',self)
    end

    def links
      @_links ||= Resource.new(resource.client,'links','LinkID',self)
    end

    def permitted_equipment
      @_permitted_equipment ||= Resource.new(resource.client,'permittedequipment','PermittedEquipmentID',self)
    end

    def addresses
      if resource.name == 'recareas'
        @_addresses ||= Resource.new(resource.client,'recareaaddresses','RecAreaAddressID',self)
      elsif resource.name == 'facilities'
        @_addresses ||= Resource.new(resource.client,'facilityaddresses','FacilityAddressID',self)
      end
    end

    def zones
      @_zones || Resource.new(resource.client,'zones','ZoneID',self)
    end

  end

end