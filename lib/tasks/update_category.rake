namespace :migrate do  
  task :update_category => :environment do

    google_vr = Category.find_by_name("Google VR")
    google_vr.update_attributes(name: "Google VR")

    windows_mixed_reality = Category.find_by_name("Windows Mixed Reality")
    windows_mixed_reality.update_attributes(name: "Windows mixed reality")

    google_vr = Category.find_by_name("Google VR")
    google_vr.update_attributes(name: "Google VR")

    htc_vive = Category.find_by_name("HTC Vive")
    htc_vive.update_attributes(name: "HTC Vive")

    oculus = Category.find_by_name("Oculus")
    oculus.update_attributes(name: "Oculus")

    playstation_vr = Category.find_by_name("Playstation VR")
    playstation_vr.update_attributes(name: "Playstation VR")

    samsung_vr = Category.find_by_name("Samsung VR")
    samsung_vr.update_attributes(name: "Samsung VR")

    steam_vr = Category.find_by_name("SteamVR")
    steam_vr.update_attributes(name: "SteamVR")

    web_vr = Category.find_by_name("WebVR")
    web_vr.update_attributes(name: "WebVR")

    vr_subcategories = ['WebVR', 'SteamVR', 'Playstation VR', 'Windows Mixed Reality', 'Samsung VR', 'Google VR', 'Oculus', 'HTC Vive']
    vr_category = Category.find_by_name("VR")

    vr_subcategories.each do |vr_subcategory|
      Category.create(name: vr_subcategory, parent_id: vr_category.id )
    end

  end
end