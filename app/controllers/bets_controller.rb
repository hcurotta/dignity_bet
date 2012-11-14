class BetsController < ApplicationController
  # GET /bets
  # GET /bets.json
  def index
    
    @bets = Bet.where("challenger_id = ? or owner_id = ?", current_user.id, current_user.id)
    
    @bet_requests = []
    @active_bets = []
    @bets_won = []
    @awaiting_accept = []
    
    @bets.each do |bet|
        @bet_requests << bet if (bet.status=='pending' && bet.owner != current_user)
        @active_bets << bet if (bet.status=='active')
        @awaiting_accept << bet if (bet.status == 'pending' && bet.owner == current_user)
        @bets_won << bet if (bet.status=="won" and bet.owner == current_user)
        @bets_won << bet if (bet.status=="lost" and bet.owner != current_user)
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end

  # GET /bets/1
  # GET /bets/1.json
  def show
    @bet = Bet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bet }
    end
  end

  # GET /bets/new
  # GET /bets/new.json
  def new
    @bet = Bet.new
    @challenger = User.find_by_id(params[:challenger_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bet }
    end
  end

  # GET /bets/1/edit
  def edit
    @bet = Bet.find(params[:id])
  end

  # POST /bets
  # POST /bets.json
  def create
    @bet = Bet.new(params[:bet])

    respond_to do |format|
      if @bet.save
        format.html { redirect_to @bet, notice: 'Bet was successfully created.' }
        format.json { render json: @bet, status: :created, location: @bet }
      else
        format.html { render action: "new" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bets/1
  # PUT /bets/1.json
  def update
    @bet = Bet.find(params[:id])

    respond_to do |format|
      if @bet.update_attributes(params[:bet])
        format.html { redirect_to @bet, notice: 'Bet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bets/1
  # DELETE /bets/1.json
  def destroy
    @bet = Bet.find(params[:id])
    @bet.destroy

    respond_to do |format|
      format.html { redirect_to bets_url }
      format.json { head :no_content }
    end
  end
  
  def pick_challenger
    
    begin
      friend_ids = current_user.facebook.get_connections("me","friends").map{ |friend| (friend["id"])}
    rescue
      redirect_to "/signout"
    else
      @friends_with_app = User.find_all_by_uid(friend_ids)
    end
  
  end
  
  def accept
    @bet = Bet.find(params[:id])
  end
  
  def determine_result
    @bet = Bet.find(params[:id])
    @role = @bet.role(current_user)
    
  end
  
  def set_result
    @bet = Bet.find(params[:id])
    @bet.set_result(current_user, params[:determination])
    
    @tense_change = {"draw" => "draw", "won" => "win", "lost" => "lose"}
    if @bet.decided? 
      @bet.post_loser_status
      @bet.status = @bet.result(@bet.owner)
      @bet.save
    end
    
  end
  
  def history
    @bets = Bet.where("challenger_id = ? or owner_id = ? and status != ?", current_user.id, current_user.id, "active")
    
    @bets_drawn = []
    @bets_won = []
    @bets_lost = []
    
    @bets.each do |bet|
        @bets_drawn << bet if (bet.status=='drew')
        @bets_won << bet if (bet.winner == current_user)
        @bets_lost << bet if (bet.winner == bet.other_guy(current_user))
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bets }
    end
  end
end
