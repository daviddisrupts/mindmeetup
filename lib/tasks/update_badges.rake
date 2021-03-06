namespace :migrate do  
  task :update_badges => :environment do
    fav_question = Badge.where(subcategory: "favorites", category: "Question")
    fav_question.find_by(rank: "bronze").update_attributes(name: "halliday_award")
    fav_question.find_by(rank: "silver").update_attributes(name: "art3mis_award")
    fav_question.find_by(rank: "gold").update_attributes(name: "parzvial_award")

    voted_question = Badge.where(subcategory: "votes", category: "Question")
    voted_question.find_by(rank: "bronze").update_attributes(name: "enzo_award")
    voted_question.find_by(rank: "silver").update_attributes(name: "yt_award")
    voted_question.find_by(rank: "gold").update_attributes(name: "hiro_award")

    pop_question = Badge.where(subcategory: "views", category: "Question")
    pop_question.find_by(rank: "bronze").update_attributes(name: "klein_award")
    pop_question.find_by(rank: "silver").update_attributes(name: "asuna_award")
    pop_question.find_by(rank: "gold").update_attributes(name: "kirito_award")

    pop_answer = Badge.where(subcategory: "votes", category: "Answer")
    pop_answer.find_by(rank: "bronze").update_attributes(name: "trinity_award")
    pop_answer.find_by(rank: "silver").update_attributes(name: "morpheus_award")
    pop_answer.find_by(rank: "gold").update_attributes(name: "neo_award")

    Badge.where(category: "Tag").destroy_all
    tags = ["windows mixed reality", "oculus go", "oculus", "oculus rift", "google daydream", "google vr", "daydream", "htc vive", "vive focus", "vive", "gear vr", "samsung gear vr", "samsung vr", "playstation vr", "psvr", "magic leap", "magic leap one", "hololens", "apple ar", "arkit", "arcore", "vuforia", "steamvr", "webvr", "mirage solo", "wmr", "windows vr", "lenovo explorer", "samsung odyssey", "dell visor", "acer windows mixed reality", "hp windows mixed reality", "lightwear", "lightpack", "mobile vr", "audio", "platform sdk", "avatar sdk", "unity", "unreal", "game design", "game development", "vr development", "ar development", "holotoolkit", "spatial mapping", "gesture", "anchors", "tutorials", "mixed reality", "virtual reality", "augmented reality"]
    Tagging.destroy_all
    Tag.destroy_all
    tags.each do |tag|
      Tag.create(name: tag, description: tag)
      Badge.create(subcategory: tag, category: "Tag", rank: "bronze", name: tag, description: "Awarded for having at least 100 total score in the #{tag.titlecase} tag.")
      Badge.create(subcategory: tag, category: "Tag", rank: "silver", name: tag, description: "Awarded for having at least 250 total score in the #{tag.titlecase} tag.")
      Badge.create(subcategory: tag, category: "Tag", rank: "gold", name: tag, description: "Awarded for having at least 500 total score in the #{tag.titlecase} tag.")
    end
 
  end
end