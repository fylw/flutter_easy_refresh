import 'dart:async';

import 'package:example/widget/skeleton_item.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _scrollDirection = Axis.vertical;

  int _count = 5;

  final _controller = EasyRefreshController(
    controlFinishRefresh: true,
  );

  // final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 1), () {
    //   PrimaryScrollController.of(context)!.position.jumpTo(-70);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyRefresh'),
      ),
      body: EasyRefresh(
        canRefreshAfterNoMore: false,
        canLoadAfterNoMore: false,
        refreshOnStart: false,
        controller: _controller,
        refreshOnStartHeader: BuilderHeader(
          triggerOffset: 70,
          clamping: false,
          position: IndicatorPosition.locator,
          processedDuration: Duration.zero,
          builder: (ctx, state) {
            if (state.mode == IndicatorMode.inactive) {
              return const SizedBox();
            }
            return Container(
              width: double.infinity,
              height: state.viewportDimension,
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Refresh on start'),
            );
          },
        ),
        header: const ClassicHeader(
          clamping: true,
          // position: IndicatorPosition.locator,
          mainAxisAlignment: MainAxisAlignment.end,
          maxOverOffset: 100,
        ),
        footer: const ClassicFooter(
          position: IndicatorPosition.locator,
          infiniteOffset: null,
          maxOverOffset: 100,
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) {
            return null;
          }
          setState(() {
            _count = 10;
          });
          _controller.finishRefresh(IndicatorResult.success);
          return IndicatorResult.success;
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) {
            return null;
          }
          setState(() {
            _count += 0;
          });
          // return IndicatorResult.noMore;
        },
        // child: ListView.builder(
        //   padding: EdgeInsets.zero,
        //   scrollDirection: scrollDirection,
        //   itemCount: _count,
        //   itemBuilder: (context, index) {
        //     return SampleListItem(
        //       direction: scrollDirection,
        //       width: scrollDirection == Axis.vertical ? double.infinity : 200,
        //     );
        //   },
        // ),
        // child: ListView(
        //   scrollDirection: scrollDirection,
        //   reverse: true,
        //   children: [
        //     const HeaderLocator(),
        //     for (int i = 0; i < _count; i++)
        //       SampleListItem(
        //         direction: scrollDirection,
        //         width: scrollDirection == Axis.vertical ? double.infinity : 200,
        //       ),
        //     const FooterLocator(),
        //   ],
        // ),
        child: CustomScrollView(
          scrollDirection: _scrollDirection,
          reverse: false,
          slivers: [
            // const HeaderLocator.sliver(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SkeletonItem(
                    direction: _scrollDirection,
                  );
                },
                childCount: _count,
              ),
            ),
            const FooterLocator.sliver(),
          ],
        ),
        // childBuilder: (context, physics) {
        //   return NestedScrollView(
        //     physics: physics,
        //     controller: _scrollController,
        //     headerSliverBuilder: (context, innerBoxIsScrolled) {
        //       return [
        //         const HeaderLocator.sliver(clearExtent: false),
        //         const SliverAppBar(
        //           title: Text('EasyRefresh'),
        //           expandedHeight: 100,
        //           pinned: true,
        //         ),
        //       ];
        //     },
        //     body: CustomScrollView(
        //       physics: physics,
        //       scrollDirection: _scrollDirection,
        //       reverse: false,
        //       slivers: [
        //         // const HeaderLocator.sliver(),
        //         SliverList(
        //           delegate: SliverChildBuilderDelegate(
        //             (context, index) {
        //               return SkeletonItem(
        //                 direction: _scrollDirection,
        //               );
        //             },
        //             childCount: _count,
        //           ),
        //         ),
        //         const FooterLocator.sliver(),
        //       ],
        //     ),
        //   );
        // },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () => _controller.callRefresh(),
      ),
    );
  }
}
