# encoding : utf-8

module TTWatcher
  module Sites

    LIST = {
#      :rutracker => Rutracker.instance, # need proxy
      :tfile     => TFile.instance,
      :rutor     => Rutor.instance }

    #
    # just list of site names that known for program
    #
    def self.list
      LIST.keys
    end

    #
    # input: +name+ : string site name
    #
    # output: if <found>     : +SITE.instance+
    #         if <not found> : raises SiteNotFound exception
    #
    def self.get_site_by_name(name)
      site = LIST[name.downcase.to_sym]

      # <!!! why this does not work???>
      # site.nil? ? raise SiteNotFound.new(name) : site
      if site.nil?
        raise SiteNotFound.new(name)
      else
        site
      end
    end

    #
    # This is supposed to been raised when someone tries to get unknown site
    # instance.
    #
    class SiteNotFound < StandardError;
      def initialize(name); super "Program does not know how to work with #{name} site"; end; end
  end # module TTWatcher::Sites
end # module TTWatcher
