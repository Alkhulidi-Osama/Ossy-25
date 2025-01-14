import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:my_portfolio/globals/app_assets.dart';
import 'package:my_portfolio/globals/app_colors.dart';
import 'package:my_portfolio/globals/constants.dart';
import 'package:my_portfolio/helper%20class/helper_class.dart';
import 'package:video_player/video_player.dart';
import '../globals/app_buttons.dart';
import '../globals/app_text_styles.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        HelperClass(
          mobile: Column(
            children: [
              buildAboutMeContents(),
              Constants.sizedBox(height: 35.0),
              buildProfilePicture(),
            ],
          ),
          tablet: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProfilePicture(),
              Constants.sizedBox(width: 25.0),
              Expanded(child: buildAboutMeContents()),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProfilePicture(),
              Constants.sizedBox(width: 25.0),
              Expanded(child: buildAboutMeContents()),
            ],
          ),
          paddingWidth: size.width * 0.1,
          bgColor: AppColors.bgColor2,
        ),
        Container(
          width: size.width,
          height: size.height * 0.5,
          child: buildParallaxSection(),
        ),
      ],
    );
  }

  FadeInRight buildProfilePicture() {
    return FadeInRight(
      duration: const Duration(milliseconds: 1200),
      child: Image.asset(
        AppAssets.work4,
        height: 450,
        width: 400,
      ),
    );
  }

  Column buildAboutMeContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeInRight(
          duration: const Duration(milliseconds: 1200),
          child: RichText(
            text: TextSpan(
              text: 'About ',
              style: AppTextStyles.headingStyles(fontSize: 30.0),
              children: [
                TextSpan(
                  text: ' AI-TRiSM',
                  style: AppTextStyles.headingStyles(
                      fontSize: 30, color: AppColors.robinEdgeBlue),
                )
              ],
            ),
          ),
        ),
        Constants.sizedBox(height: 6.0),
        FadeInLeft(
          duration: const Duration(milliseconds: 1400),
          child: Text(
            '(AI Trust, Risk, and Security Management)',
            style: AppTextStyles.montserratStyle(color: Colors.white),
          ),
        ),
        Constants.sizedBox(height: 8.0),
        FadeInLeft(
          duration: const Duration(milliseconds: 1600),
          child: Text(
            'is a framework designed to enhance control over intelligent systems by ensuring that AI aligns '
            ' with laws, ethical standards, and governance requirements. It focuses on minimizing risks '
            ' associated with AI use while simultaneously improving performance and fostering innovation.'
            ' it relies on analytical tools and monitoring techniques to ensure fair and sustainable decision-making.',
            style: AppTextStyles.normalStyle(),
          ),
        ),
        Constants.sizedBox(height: 15.0),
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: AppButtons.buildMaterialButton(
              onTap: () {}, buttonName: 'Read More'),
        )
      ],
    );
  }

  Widget buildParallaxSection() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ParallaxVideoSection(),
    );
  }
}

class ParallaxVideoSection extends StatefulWidget {
  @override
  _ParallaxVideoSectionState createState() => _ParallaxVideoSectionState();
}

class _ParallaxVideoSectionState extends State<ParallaxVideoSection> {
  late VideoPlayerController _controller;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://d2o0is6348o2o4.cloudfront.net/k0gk02%2Ffile%2Fd2c022cc75a8cee791098ba410526a3e_9d66725ba2105f1833731ade5b7f334e.mp4?response-content-disposition=inline%3Bfilename%3D%22d2c022cc75a8cee791098ba410526a3e_9d66725ba2105f1833731ade5b7f334e.mp4%22%3B&response-content-type=video%2Fmp4&Expires=1736838610&Signature=cTWx5vtD8NTg4ZOA2JG-ZOrJAQN4aUnOKXc4gwugussMH6dapGl9st2o7XOq79p9EKmVAUOkf37wH9IZOtsyT7-XJCcoGguxZIp-hY9o7G5NIxACn~n78lijBStnj8BgXeEY-0wwEEJwRm~fBXwBBVeqrhbSZUaPcAfAVWstQJnc5SRo1BP3pxNpvQoyHyFQFBpBW5h8aX4CIEqP8vJCeZx85S-wX~kKmdCov~Wd8iLnkyRCE92ylw-oAyIY-JJNxfAsV4eNXGUVXV5t99rKKa2cqjXUyHkiYu1rFbDM-UDMA0vIMc7gGQUVjDXucBqk18uhRmS3XSaNP~WkdH9Cqw__&Key-Pair-Id=APKAJT5WQLLEOADKLHBQ'),
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          _buildParallaxBackground(context),
          if (_controller.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          Positioned.fill(
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.asset(
          AppAssets.background,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    final verticalAlignment = Alignment(0.0, scrollFraction * 3 - 1.5);

    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}