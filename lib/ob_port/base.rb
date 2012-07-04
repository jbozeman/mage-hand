module MageHand
  class Base

    # @return Obsidian Portal connection for the current user.
    attr_accessor :client

    # id is declared at the end of this class definition. It is shown here, 
    # commented out because this is where you typically expect to see  
    # attribute definitions.
    # attr_simple :id

    @@simple_attributes = {}
    @@instance_attributes = {}
    
    def initialize(client, attributes=nil)
      self.client = client
      update_attributes!(attributes)
    end
     
    def update_attributes!(attributes)
      return unless attributes
      attributes.each do |key, value|
        setter = "#{key}="
        self.send setter, value if self.respond_to?(setter)
      end
    end
    
    # If an object was initialized from a mini-object, try to get the
    # rest of its data from Obsidian portal.
    # @note The object must have an id.
    # @return self
    def inflate
      # if we don't have an id, the opject has not been created on the server 
      # yet
      return unless self.id
      
      hash = JSON.parse(client.access_token.get(individual_url).body)
      update_attributes!(hash)

      self
    end
    
    # Returns the name of the model, used for ActiveModel tests.
    # @return [String] the name of the model
    def self.model_name
      @_model_name ||= ActiveModel::Name.new(self)
    end
    
    # @return [String] list of simple attributes for this class
    def self.simple_attributes
      @@simple_attributes[self.name] || []
    end
    
    def simple_attributes
      self.class.simple_attributes
    end

    def self.instance_attributes
      @@instance_attributes[self.name] || []
    end
    
    def instance_attributes
      self.class.instance_attributes
    end
    
    def self.attributes
      simple_attributes + instance_attributes
    end
      
    def attributes
      self.class.attributes
    end

    def to_json(*a)
      json_hash = {}
      self.simple_attributes.each do |attribute|
        json_hash[attribute.to_s] = self.send(attribute) if self.send(attribute)
      end
      self.instance_attributes.each do |attribute|
        json_hash[attribute.to_s] = self.send(attribute).to_json if self.send(attribute)
      end
      json_hash.to_json(*a)
    end
        
    private

      def self.attr_simple(*method_names)
        @@simple_attributes[self.name] = [] unless @@simple_attributes[self.name]
        method_names.each do |method_name|
          attr_accessor method_name
          @@simple_attributes[self.name] << method_name
        end
      end

      def self.attr_instance(method_name, options={})
         self.class_eval do
          name = method_name.to_s
          class_name = options[:class_name] || name.classify
          code = <<-CODE
            def #{name}
              @#{name}
            end

            def #{name}=(new_#{name})
              @#{name} = #{class_name}.new(client, new_#{name.singularize})
            end
          CODE
          puts code if ENV['DEBUG']
          module_eval code
          
          @@instance_attributes[self.name] = [] unless @@instance_attributes[self.name]
          @@instance_attributes[self.name] << method_name
        end
      end
      
      def self.attr_array(method_name, options={})
        self.class_eval do
          name = method_name.to_s
          class_name = options[:class_name] || name.singularize.classify
          code = <<-CODE
            def #{name}
              @#{name}
            end
            
            def #{name}=(new_#{name})
              @#{name} = []
              new_#{name}.each do |#{name.singularize}|
                @#{name} << #{class_name}.new(client, #{name.singularize})
              end
            end
          CODE
          puts code if ENV['DEBUG']
          module_eval code
        end
      end
      
      def self.inflate_if_nil(*method_names)
        self.class_eval do
          method_names.each do |method_name|
            alias_method "#{method_name.to_s}_original".to_sym, method_name
            define_method method_name do
              inflate if self.send("#{method_name.to_s}_original".to_sym).nil?
              self.send("#{method_name.to_s}_original".to_sym)
            end
          end
        end
      end

    public

    # This is here because we need to define attr_simple first but I don
    # want attr_simple in the public signature of the Base Class

    # Obsidian Portal hash id for this object
    # @return [String] hash id
    attr_simple :id
  end
end