import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/request/request_bloc.dart';
import '../../../../bloc/request/request_state.dart';
import 'pagination_controls.dart';
import 'request_card.dart';
import 'request_screen_constants.dart';

/// Main content area with requests list and pagination
class RequestListContent extends StatefulWidget {
  const RequestListContent({super.key});

  @override
  State<RequestListContent> createState() => _RequestListContentState();
}

class _RequestListContentState extends State<RequestListContent> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topCurveHeight = RequestScreenTheme.topCurveHeight(size.height);
    final smallGap = RequestScreenTheme.smallGap(size.height);

    return Padding(
      padding: EdgeInsets.only(top: topCurveHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: smallGap),
          Expanded(
            child: BlocBuilder<RequestBloc, RequestState>(
              builder: (context, state) {
                if (state is RequestLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RequestLoaded) {
                  return _buildLoadedContent(state, size);
                } else if (state is RequestError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("No hay solicitudes"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(RequestLoaded state, Size size) {
    final totalPages = state.requests.isNotEmpty
        ? (state.requests.length / RequestScreenTheme.requestsPerPage).ceil()
        : 1;

    final safePage = _currentPage.clamp(1, totalPages);
    final startIndex = (safePage - 1) * RequestScreenTheme.requestsPerPage;
    final endIndex = (safePage * RequestScreenTheme.requestsPerPage)
        .clamp(0, state.requests.length);
    final currentRequests = state.requests.isNotEmpty
        ? state.requests.sublist(startIndex, endIndex)
        : [];

    return Column(
      children: [
        Flexible(
          child: _buildRequestsContainer(currentRequests, size),
        ),
        if (state.requests.isNotEmpty)
          PaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),
      ],
    );
  }

  Widget _buildRequestsContainer(List requests, Size size) {
    final sw = size.width;
    final sh = size.height;
    final containerMarginHorizontal = sw * 0.04;
    final containerMarginVertical = sh * 0.015;
    final containerInnerPadding = sw * 0.03;
    final listPadding = sw * 0.02;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: containerMarginHorizontal,
        vertical: containerMarginVertical,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: containerInnerPadding,
        vertical: containerInnerPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RequestScreenTheme.containerRadius),
        boxShadow: RequestScreenTheme.containerShadow(),
        color: RequestScreenTheme.cardBackground,
      ),
      child: requests.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(listPadding),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: RequestCard(request: requests[index]),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(sw * 0.08),
                    decoration: BoxDecoration(
                      gradient: RequestScreenTheme.accentGradient,
                      shape: BoxShape.circle,
                      boxShadow: RequestScreenTheme.iconShadow(),
                    ),
                    child: Icon(
                      Icons.inbox_rounded,
                      size: sw * 0.15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: sh * 0.025),
                  const Text(
                    "No hay solicitudes registradas",
                    style: RequestScreenTheme.emptyMessageStyle,
                  ),
                ],
              ),
            ),
    );
  }
}
