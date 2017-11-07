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
    tags = ["vive","oculus", "psvr", "hololens", "windows mixed reality", "daydream","sanswig vr"]
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