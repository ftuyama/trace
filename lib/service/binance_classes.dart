
class AccountInfo {
  final num updateTime;
  final List<Balance> balances;
  AccountInfo.fromMap(Map m)

      : this.updateTime = m['updateTime'],
        this.balances = List<Map>.from(m['balances'])
            .map((b) => Balance.fromMap(b))
            .toList();
}

class Balance {
  final String asset;
  final String free;
  final String locked;

  Balance.fromMap(Map m)
      : this.asset = m['asset'],
        this.free = m['free'],
        this.locked = m['locked'];
}