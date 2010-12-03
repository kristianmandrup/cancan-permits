class LicensesController
  def create
    @permit = Permit.new params[:permit]
    # @permit.save
    @permit.save_to_yaml
  end

  def new
    @permit = Permit.new
  end

  def show
  end

  def edit
  end
  
  def update
    @permit = Permit.update_attributes params[:permit]
    # @permit.save
    @permit.save_to_yaml
  end
  
  def delete
    @permit = Permit.find params[:id]
    @permit.remove_from_yaml
  end
end