/*
 * @Author       : Linloir
 * @Date         : 2022-10-13 17:04:12
 * @LastEditTime : 2022-10-23 10:30:41
 * @Description  : 
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp_client/repositories/local_service_repository/local_service_repository.dart';
import 'package:tcp_client/repositories/tcp_repository/tcp_repository.dart';
import 'package:tcp_client/repositories/user_repository/user_repository.dart';
import 'package:tcp_client/search/cubit/search_cubit.dart';
import 'package:tcp_client/search/cubit/search_state.dart';
import 'package:tcp_client/search/view/history_tile.dart';
import 'package:tcp_client/search/view/user_tile.dart';

class SearchPage extends StatelessWidget {
  const SearchPage(
      {required this.localServiceRepository,
      required this.tcpRepository,
      required this.userRepository,
      super.key});

  final LocalServiceRepository localServiceRepository;
  final TCPRepository tcpRepository;
  final UserRepository userRepository;

  static Route<void> route(
          {required LocalServiceRepository localServiceRepository,
          required TCPRepository tcpRepository,
          required UserRepository userRepository}) =>
      MaterialPageRoute<void>(
          builder: (context) => SearchPage(
                localServiceRepository: localServiceRepository,
                tcpRepository: tcpRepository,
                userRepository: userRepository,
              ));

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserRepository>.value(
      value: userRepository,
      child: BlocProvider<SearchCubit>(
        create: (context) => SearchCubit(
            localServiceRepository: localServiceRepository,
            tcpRepository: tcpRepository),
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return TextField(
                      onChanged: (value) {
                        context.read<SearchCubit>().onKeyChanged(value);
                      },
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 18.0),
                      showCursor: true,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        // border: InputBorder.none,
                        // errorBorder: UnderlineInputBorder(
                        //     borderSide:
                        //         BorderSide(color: Colors.red, width: 2.0)),
                        // disabledBorder: InputBorder.none,
                        // enabledBorder: UnderlineInputBorder(
                        //     borderSide:
                        //         BorderSide(color: Colors.blue, width: 2.0)),
                        // focusedBorder: UnderlineInputBorder(
                        //     borderSide:
                        //         BorderSide(color: Colors.white, width: 2.0))),
                        hintText: 'Search',
                      ));
                },
              ),
            ),
            // ...
          ),
          body: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  if (state.userResults.isNotEmpty) ...[
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Text(
                        'Users',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ...state.userResults
                        .map((e) => UserTile(userInfo: e.userInfo))
                  ],
                  if (state.historyResults.isNotEmpty) ...[
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Text(
                        'Histories',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ...state.historyResults.map((e) =>
                        HistoryTile(userID: e.contact, message: e.message))
                  ],
                  if (state.historyResults.isEmpty &&
                      state.userResults.isEmpty) ...[
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Center(
                        child: Text(
                          'No Results',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
