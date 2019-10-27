require 'json'

module TrelloBackupRenderer
  module Parsing
    include Models

    def parse_card_json(card_json, attachments_by_id)
      cover_id_attachment = card_json.fetch('cover', {})['idAttachment']

      Card.new(
        closed: card_json['closed'],
        cover_attachment: attachments_by_id[cover_id_attachment],
        id: card_json['id'],
        id_list: card_json['idList'],
        name: card_json['name'],
        pos: card_json['pos']
      )
    end

    def parse_list_json(list_json, cards)
      List.new(
        cards: (cards.select { |card| card.id_list == list_json['id'] }),
        closed: list_json['closed'],
        id: list_json['id'],
        name: list_json['name'],
        pos: list_json['pos']
      )
    end

    def parse_board_json(board_json, attachment_paths)
      attachments_by_id = attachment_paths.transform_values { |path| Attachment.new(path: path) }
      cards = (board_json['cards'] || []).map { |card_json| parse_card_json(card_json, attachments_by_id) }
      Board.new(
        lists: (board_json['lists'] || []).map { |list_json| parse_list_json(list_json, cards) }
      )
    end

    def load_attachment_paths(dir)
      paths = {}
      Dir.glob(File.join(dir, '*_*', '*_*', 'attachments', '*')) do |path|
        if File.file?(path) && match = /\A\d+_(?<id>[a-z0-9]+).*\z/.match(File.basename(path))
          # I'm just assuming the attachment IDs are globally unique rather than scoped to the card,
          # although I wasn't able to confirm this in the API docs.
          paths[match[:id]] = path
        end
      end
      paths
    end

    def relativize_attachment_paths(paths, base_dir)
      paths.transform_values { |path| path.sub(/\A#{Regexp.quote(base_dir)}\/?/, '')}
    end

    def load_board_dir(dir)
      raise Error, "Not a directory: #{dir}" unless File.directory?(dir)
      board_file_paths = Dir.glob(File.join(dir, '*_full.json')).to_a
      raise Error, "Expected one <board_name>_full.json file in: #{dir}" unless board_file_paths.count == 1
      board_json = JSON.parse(File.read(board_file_paths.first))
      attachment_paths = relativize_attachment_paths(load_attachment_paths(dir), dir)
      parse_board_json(board_json, attachment_paths)
    end
  end
end