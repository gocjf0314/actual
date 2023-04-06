import 'package:actual/common/const/colors.dart';
import 'package:actual/rating/model/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage;
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard({
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    Key? key,
  }) : super(key: key);

  factory RatingCard.fromModel({
    required RatingModel model,
  }) {
    return RatingCard(
      avatarImage: NetworkImage(model.user.imageUrl),
      images: model.imgUrls.map((e) {
        return Image.network(e);
      }).toList(),
      rating: model.rating,
      email: model.user.username,
      content: model.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        _Body(content: content),
        Visibility(
          visible: images.isNotEmpty,
          child: SizedBox(
            height: 100,
            child: _Images(images: images),
          ),
        ),
      ],
    );
  }
}

/// 프로필, 닉네임 .... 별점
class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    required this.avatarImage,
    required this.email,
    required this.rating,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) {
            return Icon(
              index < rating
                  ? Icons.star
                  : Icons.star_border_outlined,
              color: PRIMARY_COLOR,
            );
          },
        ),
      ],
    );
  }
}

/// 리뷰글
class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: const TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

/// 리뷰 이미지
class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    required this.images,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images.mapIndexed((index, element) {
        return Padding(
          padding: EdgeInsets.only(
            top: 8.0,
            right: index != images.length - 1 ? 16.0 : 0.0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: element,
          ),
        );
      }).toList(),
    );
  }
}
