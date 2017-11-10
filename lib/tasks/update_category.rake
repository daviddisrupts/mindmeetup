namespace :migrate do  
  task :update_category => :environment do

  	day_dream = Category.find_by_name("Daydream")
  	day_dream.update_attributes(name: "Daydream")

  	holo_lense = Category.find_by_name("HoloLens")
  	holo_lense.update_attributes(name: "Hololens")

  	windows_mixed = Category.find_by_name("Windows Mixed Reality")
  	windows_mixed.update_attributes(name: "Windows mixed reality")

  	vr_subcategories = ['WebVR', 'SteamVR']
  	vr_category = Category.find_by_name("VR")

  	vr_subcategories.each do |vr_subcategory|
      Category.create(name: vr_subcategory, parent_id: vr_category.id )
    end

  end
end