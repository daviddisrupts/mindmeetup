namespace :migrate do  
  task :create_category => :environment do
        
    Category.create!([{name: "AR"},{name: "VR"}])

    ar_subcategories = ['ARKit', 'ARCore', "HoloLens", "Magic Leap", "Vuforia"]

    vr_subcategories = ['Windows Mixed Reality', 'Daydream', "Oculus", "HTC Vive", "WebVR", "SteamVR"]

    ar_category = Category.find_by_name("AR")
    vr_category = Category.find_by_name("VR")
    ar_subcategories.each do |ar_subcategory|
      Category.create(name: ar_subcategory, parent_id: ar_category.id )
    end

    vr_subcategories.each do |vr_subcategory|
      Category.create(name: vr_subcategory, parent_id: vr_category.id )
    end
  end
end