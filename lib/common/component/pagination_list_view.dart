import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/proivder/pagination_provider.dart';
import 'package:actual/common/utils/pgination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> =
Widget Function(BuildContext context, int index, T model);

typedef PaginationSeparatorBuilder =
Widget Function(BuildContext context, int index);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final PaginationSeparatorBuilder? separatorBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    this.separatorBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  scrollListener() {
    PaginationUtils.paginate(
      scrollController: scrollController,
      paginationProvider: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    if(state is CursorPaginationLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if(state is CursorPaginationError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceReFetch: true,);
            },
            child: const Text('다시시도'),
          ),
        ],
      );
    }

    final cursorPagination = state as CursorPagination<T>;
    final data = cursorPagination.data;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: data.length + 1,
        separatorBuilder: widget.separatorBuilder ?? (_, index) {
          return const SizedBox(height: 16.0);
        },
        itemBuilder: (_, index) {
          if(index == data.length) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: cursorPagination is CursorPaginationFetchingMore
                  ? const CircularProgressIndicator()
                  : const Text('마지막 데이터 입니다'),
            );
          }

          final item = data[index];

          return widget.itemBuilder(context, index, item);
        },
      ),
    );
  }
}
