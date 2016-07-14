class Api::MicropostsController < Api::ApplicationController

  def create

  end

  def destroy

  end

  private
    def microposts_params
      params.require(:micropost).permit(:content, :picture)
    end
end
