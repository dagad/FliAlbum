//
//  Photo.swift
//  FliAlbum
//
//  Created by dagad on 30/04/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import Mapper

class Photo: Mappable {
    let title: String
    let link: String
    let media: String
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorId: String
    let tags: String

    required init(map: Mapper) throws {
        title = map.optionalFrom("title") ?? ""
        link = map.optionalFrom("link") ?? ""
        media = map.optionalFrom("media") ?? ""
        dateTaken = map.optionalFrom("date_taken") ?? ""
        description = map.optionalFrom("description") ?? ""
        published = map.optionalFrom("publised") ?? ""
        author = map.optionalFrom("author") ?? ""
        authorId = map.optionalFrom("id") ?? ""
        tags = map.optionalFrom("tags") ?? ""
    }
}
