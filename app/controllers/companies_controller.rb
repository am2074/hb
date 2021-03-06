class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :ranking]
  before_action :all_companies, only: [:index, :search, :autocomplete]
  before_action :force_json, only: :autocomplete
  before_action :authenticate_user!, except: [:index, :show, :search, :autocomplete]
  load_and_authorize_resource
  
  # GET /companies
  # GET /companies.json
  def index
  end

  def search
    if params[:search].blank?
      @companies = Company.all.paginate(:page => params[:page], :per_page => 5)
    else 
      @companies = Company.search(params).paginate(:page => params[:page], :per_page => 5)
    end
    @search = params[:search] 
  end

  def autocomplete
    @companies = Company.order(:name).where("name Ilike ?","%#{params[:term]}%").limit(5)
    render json: @companies.map(&:name)
  end

  # GET /companies/1
  # GET /companies/1.json
  def show  
    @company = Company.friendly.find(params[:id])
  
  end


  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save && verify_recaptcha(model: @company)
        
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.friendly.find(params[:id])
    end

    def search_params
      params.require(:companies).permit(:search)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :website)
    end

    def all_companies
      @companies = Company.all
    end 
    
    def force_json
      request.format = :json
    end
end
