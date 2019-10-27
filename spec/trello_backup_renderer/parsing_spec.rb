RSpec.describe TrelloBackupRenderer::Parsing do
  describe '.load_board_dir' do
    it 'correctly loads test board' do
      board = TrelloBackupRenderer.load_board_dir(TEST_BOARD_DIR)
      
      lists = board.lists
      expect(lists.count).to eq(3)
      
      list0 = lists[0]
      expect(list0.closed).to be(false)
      expect(list0.name).to eq('First List')
      
      list1 = lists[1]
      expect(list1.closed).to be(false)
      expect(list1.name).to eq('Empty List')

      list2 = lists[2]
      expect(list2.closed).to be(false)
      expect(list2.name).to eq('Third List')
    end
  end
end