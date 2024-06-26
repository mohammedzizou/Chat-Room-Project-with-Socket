/*
 * @Author       : Linloir
 * @Date         : 2022-10-14 17:07:13
 * @LastEditTime : 2022-10-23 13:12:27
 * @Description  : 
 */

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:tcp_client/chat/cubit/chat_cubit.dart';
import 'package:tcp_client/chat/model/chat_history.dart';

class FileBox extends StatelessWidget {
  const FileBox({required this.history, super.key});

  final ChatHistory history;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (history.status == ChatHistoryStatus.downloading ||
              history.status == ChatHistoryStatus.sending ||
              history.status == ChatHistoryStatus.processing)
          ? null
          : () {
              EasyDebounce.debounce('findfile${history.message.contentmd5}',
                  const Duration(milliseconds: 500), () {
                context.read<ChatCubit>().openFile(message: history.message);
              });
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                child: history.status == ChatHistoryStatus.none ||
                        history.status == ChatHistoryStatus.done
                    ? Icon(
                        Icons.file_present_rounded,
                        size: 20,
                        color: history.type == ChatHistoryType.income
                            ? Colors.blue[800]
                            : Colors.white.withOpacity(0.8),
                      )
                    : history.status == ChatHistoryStatus.failed
                        ? Icon(
                            Icons.refresh_rounded,
                            size: 20,
                            color: history.type == ChatHistoryType.income
                                ? Colors.red[800]
                                : Colors.white.withOpacity(0.8),
                          )
                        : history.status == ChatHistoryStatus.processing
                            ? Container(
                                height: 16.0,
                                width: 20.0,
                                padding: const EdgeInsets.only(right: 4.0),
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballPulseSync,
                                  colors: [Colors.white.withOpacity(0.8)],
                                ),
                              )
                            : Container(
                                height: 16.0,
                                width: 20.0,
                                padding: const EdgeInsets.only(right: 4.0),
                                child: CircularProgressIndicator(
                                  color: history.type == ChatHistoryType.income
                                      ? Colors.blue[800]
                                      : Colors.white.withOpacity(0.8),
                                  strokeWidth: 2.5,
                                ),
                              )),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Text(
                history.message.contentDecoded,
                softWrap: true,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 14.0,
                    color: history.type == ChatHistoryType.income
                        ? Colors.grey[900]
                        : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
