import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrabFood Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        background: backgrounds.elementAt(Random().nextInt(backgrounds.length)),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String background;

  const HomePage({
    Key key,
    @required this.background,
  })  : assert(background != null),
        super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isMaxStart = true;

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'DEMO',
      location: BannerLocation.topEnd,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.extentBefore == 0) {
                    if (isMaxStart) {
                      return false;
                    }

                    setState(() {
                      isMaxStart = true;
                    });
                  } else {
                    if (!isMaxStart) {
                      return false;
                    }

                    setState(() {
                      isMaxStart = false;
                    });
                  }

                  return false;
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('${widget.background}'),
                            fit: BoxFit.cover,
                            alignment: AlignmentDirectional.center,
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            buildPositioned(context),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 88.0,
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDisplayDesktop(context) ? 104.0 : 24.0,
                        vertical: 24.0,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Text.rich(
                          TextSpan(
                            text: 'There\'s Something for ',
                            children: [
                              TextSpan(
                                text: 'Everyone',
                                style: TextStyle(
                                  color: Color(0xFF00b14f),
                                ),
                              ),
                            ],
                            style: TextStyle(
                              color: Color(0xFF1c1c1c),
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDisplayDesktop(context) ? 104.0 : 24.0,
                        vertical: 24.0,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: 3.0 / 2.0,
                          crossAxisSpacing: 24.0,
                          mainAxisSpacing: 48.0,
                          maxCrossAxisExtent: 320.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final category = categories.elementAt(index);

                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(RestaurantsPage.route()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Image.network(
                                        '${category.imageUrl}',
                                        fit: BoxFit.cover,
                                        alignment: AlignmentDirectional.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    '${category.name}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: categories.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Material(
                  type: MaterialType.transparency,
                  elevation: isMaxStart ? 0.0 : 8.0,
                  child: Container(
                    height: 88.0,
                    color: isMaxStart ? Colors.transparent : Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: isDisplayDesktop(context) ? 104.0 : 24.0,
                          ),
                          buildImage(context),
                          Spacer(),
                          SizedBox(
                            width: isDisplayDesktop(context) ? 104.0 : 24.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        '${isMaxStart ? 'https://food.grab.com/static/images/logo-grabfood-white.svg' : 'https://food.grab.com/static/images/logo-grabfood.svg'}',
        fit: BoxFit.cover,
        alignment: AlignmentDirectional.center,
        height: 24.0,
      );
    }

    return SvgPicture.network(
      '${isMaxStart ? 'https://food.grab.com/static/images/logo-grabfood-white.svg' : 'https://food.grab.com/static/images/logo-grabfood.svg'}',
      fit: BoxFit.cover,
      alignment: Alignment.center,
      height: 24.0,
    );
  }

  Widget buildPositioned(BuildContext context) {
    final child = SizedBox(
      width: 364.0,
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 48.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Good Evening',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF1c1c1c),
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                'Let\'s explore good food near you.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF1c1c1c),
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your location',
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(RestaurantsPage.route());
                },
                color: Color(0xFF00b14f),
                colorBrightness: Brightness.dark,
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );

    if (isDisplayDesktop(context)) {
      return Positioned(
        left: 104.0,
        top: 240.0,
        child: child,
      );
    }

    return Center(
      child: child,
    );
  }
}

class RestaurantsPage extends StatefulWidget {
  static PageRoute<T> route<T>() {
    return MaterialPageRoute<T>(
      builder: (BuildContext context) {
        return RestaurantsPage();
      },
    );
  }

  @override
  _RestaurantsPageState createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'DEMO',
      location: BannerLocation.topEnd,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 88.0,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDisplayDesktop(context) ? 104.0 : 24.0,
                      vertical: 24.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for a dish or a restaurant',
                              filled: true,
                              border: InputBorder.none,
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          SizedBox(
                            height: 112.0,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories.elementAt(index);

                                return AspectRatio(
                                  aspectRatio: 3.0 / 2.0,
                                  child: Container(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: AlignmentDirectional.center,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4.0),
                                          child: Image.network(
                                            '${category.imageUrl}',
                                            fit: BoxFit.cover,
                                            alignment: AlignmentDirectional.center,
                                          ),
                                        ),
                                        Container(
                                          alignment: AlignmentDirectional.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            '${category.name}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  width: 24.0,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDisplayDesktop(context) ? 104.0 : 24.0,
                      vertical: 24.0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Home',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color(0xFF00a5cf),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 16.0,
                              ),
                              Text(
                                'Restaurant',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color(0xFF00a5cf),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 16.0,
                              ),
                              Text(
                                'Casual Dining',
                                style: TextStyle(
                                  color: Color(0xFF1c1c1c),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Casual Dining in ',
                              children: [
                                TextSpan(
                                  text: 'Manila',
                                  style: TextStyle(
                                    color: Color(0xFF00b14f),
                                  ),
                                ),
                              ],
                              style: TextStyle(
                                color: Color(0xFF1c1c1c),
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDisplayDesktop(context) ? 104.0 : 24.0,
                      vertical: 24.0,
                    ),
                    sliver: buildSliverGrid(context),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Material(
                  type: MaterialType.transparency,
                  elevation: 8.0,
                  child: Container(
                    height: 88.0,
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: isDisplayDesktop(context) ? 104.0 : 24.0,
                          ),
                          buildImage(context),
                          Spacer(
                            flex: 2,
                          ),
                          buildTextField(context),
                          SizedBox(
                            width: isDisplayDesktop(context) ? 104.0 : 24.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        'https://food.grab.com/static/images/logo-grabfood.svg',
        fit: BoxFit.cover,
        alignment: AlignmentDirectional.center,
        height: 24.0,
      );
    }

    return SvgPicture.network(
      'https://food.grab.com/static/images/logo-grabfood.svg',
      fit: BoxFit.cover,
      alignment: Alignment.center,
      height: 24.0,
    );
  }

  Widget buildTextField(BuildContext context) {
    if (isDisplayDesktop(context)) {
      return Expanded(
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Type your location',
            isDense: true,
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        Icons.location_on,
        color: Colors.red,
      ),
      onPressed: () {},
    );
  }

  Widget buildSliverGrid(BuildContext context) {
    if (isDisplayDesktop(context)) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 4.0 / 3.0,
          crossAxisSpacing: 24.0,
          mainAxisSpacing: 48.0,
          maxCrossAxisExtent: 320.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final restaurant = restaurants.elementAt(index);

            return buildGestureDetector(context, restaurant, () => Navigator.of(context).push(RestaurantDetailsPage.route()));
          },
          childCount: restaurants.length,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final restaurant = restaurants.elementAt(index);

          return buildGestureDetector(context, restaurant, () => Navigator.of(context).push(RestaurantDetailsPage.route()));
        },
        childCount: restaurants.length,
      ),
    );
  }

  Widget buildGestureDetector(BuildContext context, Restaurant restaurant, GestureTapCallback onTap) {
    if (isDisplayDesktop(context)) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    '${restaurant.imageUrl}',
                    fit: BoxFit.cover,
                    alignment: AlignmentDirectional.center,
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                '${restaurant.name}',
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF1C1C1C),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${restaurant.categories[0]}, ${restaurant.categories[1]}, ${restaurant.categories[2]}',
                maxLines: 1,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF676767),
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '${restaurant.rating.toStringAsFixed(1)}',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF676767),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Color(0xFF676767),
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '${restaurant.minutes} mins',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF676767),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF676767),
                        size: 14.0,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        '${restaurant.kilometers.toStringAsFixed(1)} km',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF676767),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 88.0,
      margin: EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0 / 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  '${restaurant.imageUrl}',
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      '${restaurant.name}',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF1C1C1C),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${restaurant.categories[0]}, ${restaurant.categories[1]}, ${restaurant.categories[2]}',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF676767),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14.0,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '${restaurant.rating.toStringAsFixed(1)}',
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              color: Color(0xFF676767),
                              size: 14.0,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              '${restaurant.minutes} mins',
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Color(0xFF676767),
                              size: 14.0,
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Text(
                              '${restaurant.kilometers.toStringAsFixed(1)} km',
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF676767),
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  static PageRoute<T> route<T>() {
    return MaterialPageRoute(
      builder: (context) {
        return RestaurantDetailsPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'DEMO',
      location: BannerLocation.topEnd,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Material(
                  type: MaterialType.transparency,
                  elevation: 8.0,
                  child: Container(
                    height: 88.0,
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: isDisplayDesktop(context) ? 104.0 : 24.0,
                          ),
                          buildImage(context),
                          Spacer(
                            flex: 2,
                          ),
                          buildExpanded(context),
                          SizedBox(
                            width: isDisplayDesktop(context) ? 104.0 : 24.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDisplayDesktop(context) ? 104.0 : 24.0,
                    vertical: 24.0,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        buildIceCream(context),
                        SizedBox(
                          height: 24.0,
                        ),
                        Text(
                          'Oops, Something Went Wrong',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1c1c1c),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'This page is not yet implemented, so don\'t try refreshing the page.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF676767),
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          '😛😜😝',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF676767),
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
//            Text(
//              'While we figure out what happened, try refreshing the page.',
//              style: TextStyle(
//                color: Color(0xFF676767),
//                fontSize: 16.0,
//                fontWeight: FontWeight.normal,
//              ),
//            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIceCream(BuildContext context) {
    return Image.asset(
      'assets/images/error.png',
      fit: BoxFit.cover,
      alignment: AlignmentDirectional.center,
      width: 240.0,
      height: 240.0,
    );
  }

  Widget buildImage(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        'https://food.grab.com/static/images/logo-grabfood.svg',
        fit: BoxFit.cover,
        alignment: AlignmentDirectional.center,
        height: 24.0,
      );
    }

    return SvgPicture.network(
      'https://food.grab.com/static/images/logo-grabfood.svg',
      fit: BoxFit.cover,
      alignment: Alignment.center,
      height: 24.0,
    );
  }

  Widget buildExpanded(BuildContext context) {
    if (isDisplayDesktop(context)) {
      return Expanded(
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Type your location',
            isDense: true,
            prefixIcon: Icon(
              Icons.location_on,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        Icons.location_on,
        color: Colors.red,
      ),
      onPressed: () {},
    );
  }
}

class Category {
  const Category({
    @required this.imageUrl,
    @required this.name,
  })  : assert(imageUrl != null),
        assert(name != null);

  final String imageUrl;
  final String name;
}

class Restaurant {
  const Restaurant({
    @required this.imageUrl,
    @required this.name,
    @required this.categories,
    @required this.rating,
    @required this.minutes,
    @required this.kilometers,
  });

  final String imageUrl;
  final String name;
  final List<String> categories;
  final double rating;
  final num minutes;
  final double kilometers;
}

const backgrounds = [
  'https://food.grab.com/static/page-home/PH-new-1.jpg',
  'https://food.grab.com/static/page-home/PH-new-2.jpg',
  'https://food.grab.com/static/page-home/PH-new-3.jpg',
  'https://food.grab.com/static/page-home/PH-new-4.jpg',
];

const categories = [
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/95/icons/upload-photo-icon_a1a04c96befd4cc6b855174e7bf855b2_1549033366202437809.jpeg',
    name: 'Kiosk',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/89/icons/Japanese_c57eb2e1cb67478aba81c6363d7e7a9d_1547819166986139945.jpg',
    name: 'Japanese',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/23/icons/upload-photo-icon_3d3b9d549d1644cd98d80da55f456042_1549034041055099770.jpeg',
    name: 'Beef',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/113/icons/upload-photo-icon_53822360ca33413b89e38e1dd30d489a_1548777327787252021.jpeg',
    name: 'Milk Tea',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/62/icons/FastFood_4710e425c3d24db2aa4280aa207a22d3_1547819143037208832.jpg',
    name: 'Fast Food',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/39/icons/CasualDining_a90dc14dd87e4206bb347722ed45436a_1547118526663359825.jpg',
    name: 'Casual Dining',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/28/icons/BreakfastAndBrunch_11c1a86420804b208544a2af4b49ead4_1547118497453519181.jpg',
    name: 'Breakfast and Lunch',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/135/icons/Pizza_32aed38d4c1d4dbcb2fe711f0aeb6e15_1547819221409327403.jpg',
    name: 'Pizza',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/45/icons/Chinese_8c752d09002d4ecdaa8a510ffca66d42_1547819101197342007.jpg',
    name: 'Chinese',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/43/icons/Chicken_d4725da9243a46e79740d2e70fd28314_1547819095170793371.jpg',
    name: 'Chicken',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/6/icons/upload-photo-icon_5a57c3914f0149fca3fa7fe49a11fb7d_1549033777093706140.jpeg',
    name: 'Bakery',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/33/icons/Burgers_585ab6cfd5eb4a3f8e20f61222884637_1547819083514565135.jpg',
    name: 'Burgers',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/88/icons/Italian_dea6f89e208a4053a020ad1c8ce131b3_1547819160954951799.jpg',
    name: 'Italian',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/63/icons/Filipino_1225b0fdb8a6426289c35cea768965f9_1547819149007472715.jpg',
    name: 'Filipino',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/4/icons/e3218ab8ac6e4a70b592a3e8807df273_1585220358238974717.jpeg',
    name: 'Asian',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/157/icons/eb8ea703d1f84b218b79b0f860e99425_1562559054203677203.jpeg',
    name: 'Snacks',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/24/icons/upload-photo-icon_026ef33112374534a605781932ffcda5_1549034070930415662.jpeg',
    name: 'Beverages',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/137/icons/upload-photo-icon_a202b86d4dd94f99997d3cbee70bf325_1549032874611204371.jpeg',
    name: 'Pork',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/142/icons/upload-photo-icon_3fb18ebb507c47ee988d3eaa27339521_1549032804931564549.jpeg',
    name: 'Quick Bites',
  ),
  Category(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/cuisine/3/icons/3c9053bc4aea4f75b62ef5fd2ea6d554_1561522870503763471.jpeg',
    name: 'American',
  ),
];

const restaurants = [
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CY6YVVJJR8NXFE/hero/f849b20f04224b98ba79a9ec688df7c9_1579594985986294943.jpeg',
    name: 'Rarjap Sushi House - V. Concepcion Street',
    categories: ['Japanese', 'Sushi', 'Casual Dining'],
    rating: 4.5,
    minutes: 25,
    kilometers: 1.5,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CY3VAZCEDGNEVA/hero/13d5363a12594ef2979c01bc4db06988_1573271420764027785.jpeg',
    name: 'Pepper Lunch Express - Lucky Chinatown',
    categories: ['Japanese', 'Beef', 'Food Court'],
    rating: 4.6,
    minutes: 29,
    kilometers: 1.2,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYNYGPNFRGJHRT/hero/3ee3505b518b4414a7a799b94dbf60c8_1560851475829730402.jpeg',
    name: 'TakoyaKiks - UST',
    categories: ['Japanese', 'Snacks', 'Kiosk'],
    rating: 4.6,
    minutes: 22,
    kilometers: 1.4,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYUCFGKUC2LASE/hero/0eca02552971408aab5881766d7ff3fb_1565925656447189228.jpeg',
    name: 'Karate Kid - Centro Escolar University',
    categories: ['Japanese', 'Chicken', 'Casual Dining'],
    rating: 4.2,
    minutes: 25,
    kilometers: 0.9,
  ),
  Restaurant(
    imageUrl:
        'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYMAT8DBDATVPE/hero/upload-photo-Hero_Photo_028efcfcc8c54ca7a61f898c1bf0d3f8_1556087960679157420.jpeg',
    name: 'Hashi Donburi - Dapitan Street',
    categories: ['Japanese', 'Sushi', 'Casual Dining'],
    rating: 4.2,
    minutes: 25,
    kilometers: 1.7,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/PHGFSTI0000018o/hero/0b73c2af14b649aeadc64a5a39590dc1_1577078487815294927.jpeg',
    name: 'Tokyo Tokyo - SM Manila',
    categories: ['Japanese', 'Seafood', 'Casual Dining'],
    rating: 4.5,
    minutes: 35,
    kilometers: 1.0,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYVFJTL1MB6VGE/hero/9918b29565024c95bc8745abb7bc0918_1582769423020466992.jpeg',
    name: 'Ramen Naijiro - Fusebox',
    categories: ['Japanese', 'Chicken', 'Casual Dining'],
    rating: 3.6,
    minutes: 24,
    kilometers: 1.5,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CZCEDCB2FCL1RT/hero/5f15fd90835f466a9dbf8ccd8ea0a0da_1584418878551156569.jpeg',
    name: 'Sakura Hanami - Fusebox Foodpark',
    categories: ['Milk Tea', 'Beverages', 'Japanese'],
    rating: 4.1,
    minutes: 37,
    kilometers: 1.5,
  ),
  Restaurant(
    imageUrl:
        'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/AWlNKlJefYWaYaQC5d7t/hero/upload-photo-Hero_Photo_01dbd76e3a1f46f68490aa26238c20d5_1551777862450542007.jpeg',
    name: 'Legit Restaurant - P. Noval',
    categories: ['Japanese', 'Seafood', 'Casual Dining'],
    rating: 3.7,
    minutes: 25,
    kilometers: 1.0,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYUCFGMCGN2HV6/hero/ec7c9832d57149c997404fc1d2bacd24_1562230430678409608.jpeg',
    name: 'Tempura Japanese Grill - UN Avenue',
    categories: ['Japanese', 'Sushi', 'Casual Dining'],
    rating: 4.3,
    minutes: 25,
    kilometers: 2.1,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CY3DJBBYCEABVN/hero/e9a4abd84cde4abd91205fac3d29a0e0_1574991108864743440.jpeg',
    name: 'Tokyo Tempura - Lucky Chinatown',
    categories: ['Japanese', 'Seafood', 'Food Court'],
    rating: 4.5,
    minutes: 25,
    kilometers: 1.2,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/PHGFSTI000001d2/hero/3f95d87fdea443609ca7a1ea9b4c144a_1580181373227372455.jpeg',
    name: 'Crazy Chops - Asturias Street Sampaloc',
    categories: ['Japanese', 'Chicken', 'Casual Dining'],
    rating: 3.5,
    minutes: 36,
    kilometers: 0.8,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYMUEJVENP4TEE/hero/78918d3d9cd44675b1d3ce288636758c_1562576748405675163.jpeg',
    name: 'Katsuman Japanese Restaurant - Roxas Blvd St.',
    categories: ['Japanese', 'Ramen', 'Casual Dining'],
    rating: 3.1,
    minutes: 36,
    kilometers: 2.6,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CZADLTTJTJ4UJN/hero/6aa738e145c540e1adb5b089a0692998_1580354425630093680.jpeg',
    name: 'Jeddy\'s Luncheonette - Felix Huertas',
    categories: ['Japanese', 'Dim Sum', 'Casual Dining'],
    rating: 3.4,
    minutes: 37,
    kilometers: 1.7,
  ),
  Restaurant(
    imageUrl: 'https://d1sag4ddilekf6.cloudfront.net/compressed/merchants/2-CYWCVTKYA6EDTT/hero/221489e7c3e24e6f817192150f5e0e4e_1566439575459995632.jpeg',
    name: 'Sumi-Sumi Restaurant - Ermita',
    categories: ['Asian', 'Japanese', 'Quick Bites'],
    rating: 4.0,
    minutes: 36,
    kilometers: 2.6,
  ),
];

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:flutter/material.dart';

enum DisplayType {
  desktop,
  mobile,
}

const _desktopPortraitBreakpoint = 700.0;
const _desktopLandscapeBreakpoint = 1000.0;

/// Returns the [DisplayType] for the current screen. This app only supports
/// mobile and desktop layouts, and as such we only have one breakpoint.
DisplayType displayTypeOf(BuildContext context) {
  final orientation = MediaQuery.of(context).orientation;
  final width = MediaQuery.of(context).size.width;

  if ((orientation == Orientation.landscape && width > _desktopLandscapeBreakpoint) ||
      (orientation == Orientation.portrait && width > _desktopPortraitBreakpoint)) {
    return DisplayType.desktop;
  } else {
    return DisplayType.mobile;
  }
}

/// Returns a boolean if we are in a display of [DisplayType.desktop]. Used to
/// build adaptive and responsive layouts.
bool isDisplayDesktop(BuildContext context) {
  return displayTypeOf(context) == DisplayType.desktop;
}

/// Returns a boolean if we are in a display of [DisplayType.desktop] but less
/// than [_desktopLandscapeBreakpoint] width. Used to build adaptive and responsive layouts.
bool isDisplaySmallDesktop(BuildContext context) {
  return isDisplayDesktop(context) && MediaQuery.of(context).size.width < _desktopLandscapeBreakpoint;
}
