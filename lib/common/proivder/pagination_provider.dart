import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/pagination_params.dart';

class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
> extends StateNotifier<CursorPaginationBase> {
  final U repository;

  PaginationProvider({
    required this.repository,
  }) : super(CursorPaginationLoad()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // true - Get more data
    // false - refresh
    bool fetchMore = false,

    // Reloading force
    // true - CursorPaginationLoading()
    bool forceReFetch = false,
  }) async {
    try {
      // 가져올 데이터도 없고 강제 새로 고침도 안 함
      if(state is CursorPagination && !forceReFetch) {
        final pState = state as CursorPagination;
        if(!pState.meta.hasMore) return;
      }

      // 현재 페이지 로딩 여부
      final isLoading = state is CursorPaginationLoad;
      // 새로고침 여부
      final isReFetching = state is CursorPaginationReFetching;
      // 추가 데이터 존재 여부
      final isFetchingMore = state is CursorPaginationFetchingMore;
      // 더 가져올 데이터가 있는 와중에 하나라도 true이면 함수 빠져나감
      // 로딩이 끝나야 데이터가 반환 될 수 있기 때문이다.
      if(fetchMore && (isLoading || isReFetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // 더 가져올 데이터가 있으면 현재 리스트의
      // 마지막 데이터 고유값을 파라미터로 전달
      if(fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        // 처음부터 데이터 가져 옴
        // 데이터가 있는 상황이면 기존 것 보존한 채로 fetch
        if(state is CursorPagination && !forceReFetch) {
          // 새로 고침
          final pState = state as CursorPagination<T>;

          state = CursorPaginationReFetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          // 데이터를 유지하지 않아도 됨
          state = CursorPaginationLoad();
        }
      }

      final resp = await repository.paginate(
        params: paginationParams,
      );

      // 현재 데이터를 더 가져오고 있다면
      // 로드 된 데이터 리스트 추가
      if(state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        // 강제 새로 고침에 해당 됨
        state = resp;
      }
    } catch(e, s) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}