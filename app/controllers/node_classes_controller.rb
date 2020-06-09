class NodeClassesController < InheritedResources::Base
  respond_to :html, :json, :yaml
  before_action :raise_unless_using_external_node_classification
  before_action :raise_if_enable_read_only_mode, :only => [:new, :edit, :create, :update, :destroy]

  include SearchableIndex

  protected

  def node_class_params
    params.require(:node_class).permit(:name, :description)
  end

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_id_or_name!(params[:id]))
  end
end
