import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/request/request_state.dart';
import '../../../../bloc/request/request_bloc.dart';
import 'request_card.dart';
import 'pagination_controls.dart';
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
    final containerMarginHorizontal = RequestScreenTheme.containerMarginHorizontal(size.width);
    final containerMarginVertical = RequestScreenTheme.containerMarginVertical(size.height);
    final containerInnerPadding = RequestScreenTheme.containerInnerPadding(size.width);
    final listPadding = RequestScreenTheme.listPadding(size.width);

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
        color: RequestScreenTheme.backgroundColor,
      ),
      child: requests.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(listPadding),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(request: requests[index]);
              },
            )
          : Center(
              child: Text(
                "No hay solicitudes registradas",
                style: RequestScreenTheme.emptyMessageStyle,
              ),
            ),
    );
  }
}
