module EventSourcery
  module Rails
    class Command
      include ActiveModel::Validations

      attr_reader :aggregate_id

      def initialize(aggregate_id:)
        @aggregate_id = aggregate_id
      end

      def self.attributes(*attributes)
        attr_reader *attributes

        method_arguments = attributes.map { |arg| "#{arg}:" }.join(', ')
        method_assignments = attributes.map { |arg| "@#{arg} = #{arg}" }.join(';')
        method_attrs_to_hash = attributes.map { |arg| "#{arg}: #{arg}" }.join(',')

        class_eval <<~CODE
          def initialize(aggregate_id:, #{method_arguments})
            @aggregate_id = aggregate_id
            #{method_assignments}
          end

          def to_hash
            {#{method_attrs_to_hash}}
          end
        CODE
      end
    end
  end
end
