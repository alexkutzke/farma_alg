require 'spec_helper'

describe 'Homes' do
  describe 'GET /homes' do
    it 'works! (now write some real specs)' do
      get root_path
      response.status.should be(200)
    end
  end
end
