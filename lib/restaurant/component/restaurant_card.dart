import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

import '../model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final bool isDetail;
  final String? detail;
  final String? heroKey;

  const RestaurantCard({
    required this.restaurant,
    this.heroKey,
    this.isDetail = false,
    this.detail,
    Key? key,
  }) : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool? isDetail = false,
    String? detail,
  }) => RestaurantCard(
    restaurant: model,
    isDetail: isDetail!,
    detail: model is RestaurantDetailModel ? model.detail : null,
    heroKey: model.id,
  );

  Widget imageWidget() => ClipRRect(
    borderRadius: BorderRadius.circular(isDetail ? 0.0 : 12.0),
    child: Image.network(
      restaurant.thumbUrl,
      fit: BoxFit.cover,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(heroKey != null)
          Hero(
            tag: ObjectKey(heroKey),
            child: imageWidget(),
          ),
        if(heroKey == null) imageWidget(),
        const SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDetail ? 16 : 0,
            vertical: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                restaurant.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 5.0),
              /// stringList.json(separator) => PlainString Divided from separator
              /// example: [ 1, 2, 3, 4 ], separator: ' Q ' => '1 Q 2 Q 3 Q 4'
              Text(
                restaurant.tags.join(' '),
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: restaurant.ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: restaurant.ratingsCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '${restaurant.deliveryTime} 분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: restaurant.deliveryFee > 0 ? '${restaurant.deliveryFee}원' : '무료',
                  ),
                ],
              ),
              Visibility(
                visible: detail != null && isDetail,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 16,
                    ),
                    child: Text(detail.toString()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget renderDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {

  final IconData icon;
  final String label;

  _IconText({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        SizedBox(width: 5.0,),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

