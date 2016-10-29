# encoding: utf-8

module TTWatcher
module Torrents
module Normalization

  #
  #
  #
  module Rutor
    class << self
      include Helpers

      #
      #
      #
      def mutate!(params)
        mutate_name! params
        mutate_date! params
        mutate_size! params
        mutate_seeders! params
        mutate_leeches! params
      end

      private

      #
      #
      #
      #
      def rutor_formats
        return @rutor_formats unless @rutor_formats.is_a? NilClass
        @rutor_formats = Hash.new {|hash, key| hash[key] = :unknown }

        load_formats['rutor'].each_pair do |key, values|
          values.each { |v| @rutor_formats[v.to_sym] = key.to_sym }
        end
        @rutor_formats
      end

      #
      # params[:name] format:
      #
      # >>> %name% [/ %second_name%] [%optional_param%] (%year%) %category_type% [%optional_param2%]
      #
      def mutate_name!(params)
        params[:extra] ||= {}

        name, content_created, type = params[:name].split(/[(](.*)[)]/)

        content_created = :unknown if content_created.nil? || content_created.empty?
        params[:extra][:content_created] = content_created

        optional_param    = name.match(/\[.*\]/).to_s.tr('[]','')
        name, second_name = name.sub(/\[.*\]/,'').to_s.split('/')

        if type && type.length > 1
          type_mask = type.split.first.downcase.gsub(',','').to_sym
        end

        params[:name]                   = name
        params[:extra][:type]           = rutor_formats[type_mask]
        params[:extra][:subtype]        = type_mask
        params[:extra][:optional_param] = optional_param
        params[:extra][:second_name]    = second_name
      end

      def mutate_date!(params)
        params[:added_date] = Date.parse(params[:added_date])
      end

      def mutate_size!(params)
        return params[:size] = :unknown if params[:size].nil?
        val, type = params[:size].to_s.split(' ')
        params[:size] = "#{val.to_i * conversion_calculator(type)} bytes"
      end

      def mutate_seeders!(params)
        params[:seeders] = params[:seeders].gsub(' ','').to_i
      end

      def mutate_leeches!(params)
        params[:leeches] = params[:leeches].gsub(' ','').to_i
      end
    end # class << self
  end # module Normalization::Rutor
end # module Torrents::Normalization
end # module TTWatcher::Torrents
end # module TTWatcher
